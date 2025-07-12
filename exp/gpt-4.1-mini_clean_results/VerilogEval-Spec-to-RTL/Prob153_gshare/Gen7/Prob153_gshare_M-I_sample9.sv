module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Register
    reg [6:0] GHR;

    // Registered indices and outputs for synchronous PHT read
    reg [6:0] predict_index_reg;
    reg [1:0] predict_counter_reg;
    reg       predicted_taken_bit_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Compute indices combinationally for training (no timing hazard)
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            predict_index_reg <= 7'b0;
            predict_counter_reg <= 2'b01; // weakly not taken
            predicted_taken_bit_reg <= 1'b0;
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // 1. Update PHT if training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 2. Register prediction index if predict_valid to read PHT synchronously
            if (predict_valid) begin
                predict_index_reg <= predict_pc ^ GHR;
                // The PHT read will be available next cycle, so prediction outputs lag by one cycle
                // To keep prediction outputs aligned, we'll output previous cycle's registered PHT value
            end

            // 3. Read PHT synchronously at predict_index_reg
            predict_counter_reg <= PHT[predict_index_reg];
            predicted_taken_bit_reg <= PHT[predict_index_reg][1]; // MSB as taken bit

            // 4. Output prediction results based on previous cycle's prediction validity:
            // We'll keep outputs registered and update only when predict_valid from previous cycle was high.
            // To do this, store predict_valid from previous cycle
        end
    end

    // For proper prediction output update timing, use a pipeline register for predict_valid:
    reg predict_valid_d;
    reg [6:0] GHR_d; // register GHR from previous cycle for output predict_history

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_valid_d <= 1'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
            GHR_d <= 7'b0;
        end else begin
            predict_valid_d <= predict_valid;
            GHR_d <= GHR;

            if (predict_valid_d) begin
                predict_taken <= predicted_taken_bit_reg;
                predict_history <= GHR_d;
            end
            // else outputs hold previous values
        end
    end

    // 5. Update GHR with priority:
    // If train mispredicted, recover GHR to train_history
    // Else if predict_valid, shift in predicted_taken_bit from previous cycle's registered PHT data
    // This matches the timing that prediction outputs correspond to data from previous cycle
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // already initialized above
        end else begin
            if (train_valid && train_mispredicted) begin
                GHR <= train_history;
            end else if (predict_valid_d) begin
                GHR <= {GHR[5:0], predicted_taken_bit_reg};
            end
            // else hold GHR unchanged
        end
    end

endmodule