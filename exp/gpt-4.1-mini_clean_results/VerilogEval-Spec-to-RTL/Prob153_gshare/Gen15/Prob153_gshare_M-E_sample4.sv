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
    integer i;

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Internal wires for index and read data
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    reg [1:0] pht_read_data;

    // Saturating counter increment/decrement helpers
    function [1:0] saturate_inc(input [1:0] val);
        begin
            saturate_inc = (val == 2'b11) ? 2'b11 : val + 1;
        end
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        begin
            saturate_dec = (val == 2'b00) ? 2'b00 : val - 1;
        end
    endfunction

    // Combinational read of PHT entry indexed by predict_index
    // Implemented as a combinational read from reg array for simulation,
    // but will be inferred as synchronous RAM in synthesis.
    always @(*) begin
        pht_read_data = PHT[predict_index];
    end

    // Main sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT based on training inputs
            if (train_valid) begin
                if (train_taken)
                    PHT[train_index] <= saturate_inc(PHT[train_index]);
                else
                    PHT[train_index] <= saturate_dec(PHT[train_index]);
            end

            // Update GHR with priority
            if (train_valid && train_mispredicted) begin
                // Recover GHR after misprediction flush
                ghr <= train_history;
            end else if (train_valid) begin
                // Shift in actual branch outcome
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predicted bit from current read
                ghr <= {ghr[5:0], pht_read_data[1]};
            end
            // else hold ghr

            // Update prediction outputs only when predict_valid asserted
            if (predict_valid) begin
                predict_taken <= pht_read_data[1]; // MSB = prediction bit
                predict_history <= ghr;
            end
            // else hold previous outputs (stable output)
        end
    end

endmodule