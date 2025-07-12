module TopModule (
    input        clk,
    input        areset,

    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // Saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly Not Taken
        WN = 2'b01, // Weakly Not Taken
        WT = 2'b10, // Weakly Taken
        ST = 2'b11; // Strongly Taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Saturating increment function
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case(val)
                SN: saturate_inc = WN;
                WN: saturate_inc = WT;
                WT: saturate_inc = ST;
                ST: saturate_inc = ST;
                default: saturate_inc = val;
            endcase
        end
    endfunction

    // Saturating decrement function
    function [1:0] saturate_dec(input [1:0] val);
        begin
            case(val)
                ST: saturate_dec = WT;
                WT: saturate_dec = WN;
                WN: saturate_dec = SN;
                SN: saturate_dec = SN;
                default: saturate_dec = val;
            endcase
        end
    endfunction

    // Compute prediction index and predicted counter combinationally
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predict_taken_comb = predict_counter[1]; // MSB indicates taken

    // Prediction outputs combinational, zero if no valid prediction
    assign predict_taken = predict_valid ? predict_taken_comb : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Variables for synchronous update
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Sequential logic: update PHT and GHR on posedge clk or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN;
            end
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR prioritizing training misprediction recovery
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken_comb};
            end
            // else retain ghr unchanged
        end
    end

endmodule