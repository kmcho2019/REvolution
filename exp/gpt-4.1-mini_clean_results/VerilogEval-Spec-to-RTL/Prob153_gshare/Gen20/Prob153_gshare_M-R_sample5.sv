module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register
    reg [6:0] ghr;

    // Registers for prediction outputs
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Registered prediction inputs to align reads
    reg [6:0]  predict_pc_reg;
    reg        predict_valid_reg;

    // Read PHT address registers for prediction and training
    reg [6:0]  predict_index_reg;
    reg [6:0]  train_index_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    endfunction

    integer i;

    // Read PHT entries combinationally at registered addresses (read-first RAM behavior)
    reg [1:0] pht_predict_entry;
    reg [1:0] pht_train_entry;

    always @(*) begin
        pht_predict_entry = pht[predict_index_reg];
        pht_train_entry = pht[train_index_reg];
    end

    // Compute indexes combinationally
    wire [6:0] predict_index_next = predict_pc ^ ghr;
    wire [6:0] train_index_next = train_pc ^ train_history;

    // Determine predicted taken based on current PHT entry MSB
    wire predict_taken_wire = pht_predict_entry[1];

    // Assign output ports from registers
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end

            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
            predict_pc_reg <= 7'b0;
            predict_valid_reg <= 1'b0;
            predict_index_reg <= 7'b0;
            train_index_reg <= 7'b0;
        end else begin
            // Register prediction inputs and indexes to align with PHT read
            predict_pc_reg <= predict_pc;
            predict_valid_reg <= predict_valid;
            predict_index_reg <= predict_index_next;
            train_index_reg <= train_index_next;

            // Update PHT entry on training only
            if (train_valid) begin
                pht[train_index_reg] <= saturate_update(pht_train_entry, train_taken);
            end

            // Register prediction output on clock edge when predict_valid
            if (predict_valid_reg) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= ghr;
            end

            // Update GHR with precedence: training > prediction
            if (train_valid) begin
                if (train_mispredicted) begin
                    // Recover history to flush state
                    ghr <= train_history;
                end else begin
                    // Update with actual branch outcome
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Update with predicted outcome
                ghr <= {ghr[5:0], predict_taken_wire};
            end
            // else no change to ghr
        end
    end

endmodule