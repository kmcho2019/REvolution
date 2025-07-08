module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // PHT size
    localparam PHT_SIZE = 128;
    localparam COUNTER_BITS = 2;

    // 2-bit saturating counters:
    // 00: strongly not taken
    // 01: weakly not taken
    // 10: weakly taken
    // 11: strongly taken

    // Pattern History Table: 128 entries of 2-bit counters
    reg [COUNTER_BITS-1:0] pht [0:PHT_SIZE-1];

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Calculate indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT counters combinationally
    wire [1:0] pht_counter_predict = pht[predict_index];
    wire [1:0] pht_counter_train = pht[train_index];

    // Prediction: taken if MSB of 2-bit counter is 1
    assign predict_taken = (pht_counter_predict[1] == 1'b1) & (predict_valid == 1'b1);
    assign predict_history = ghr;

    integer i;

    // Synchronous logic: update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT to weakly not taken (01)
            ghr <= 7'b0;
            for (i = 0; i < PHT_SIZE; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Update PHT on training if train_valid
            if (train_valid) begin
                // Update saturating counter at train_index
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                    default: pht[train_index] <= 2'b01;
                endcase
            end

            // Update GHR:
            // If training with mispredict, restore GHR to train_history.
            // Else if prediction valid, update GHR by shifting in predicted bit.
            // If both train_mispredicted and predict_valid in same cycle, training takes precedence.
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift left and insert predicted taken bit (predict_taken)
                ghr <= {ghr[5:0], predict_taken};
            end
            // else no update to ghr
        end
    end

endmodule