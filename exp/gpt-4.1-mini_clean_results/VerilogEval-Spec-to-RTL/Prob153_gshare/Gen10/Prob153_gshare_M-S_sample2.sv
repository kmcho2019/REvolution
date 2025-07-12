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
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT): 128 entries, 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Function to increment saturating counter
    function [1:0] saturate_inc(input [1:0] val);
        case(val)
            SN: saturate_inc = WN;
            WN: saturate_inc = WT;
            WT: saturate_inc = ST;
            ST: saturate_inc = ST;
            default: saturate_inc = val;
        endcase
    endfunction

    // Function to decrement saturating counter
    function [1:0] saturate_dec(input [1:0] val);
        case(val)
            ST: saturate_dec = WT;
            WT: saturate_dec = WN;
            WN: saturate_dec = SN;
            SN: saturate_dec = SN;
            default: saturate_dec = val;
        endcase
    endfunction

    // Compute prediction index and read current counter combinationally
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = pht[predict_index];

    // Predicted taken if MSB of counter is 1
    wire predict_taken_comb = predict_counter[1];

    // Outputs: valid prediction outputs, else zero
    assign predict_taken   = predict_valid ? predict_taken_comb : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Compute training index ahead
    wire [6:0] train_index = train_pc ^ train_history;

    // Sequential logic for reset, PHT update, and GHR update
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN; // Initialize to weakly not taken
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR with training misprediction priority
            if (train_valid && train_mispredicted) begin
                // Restore GHR to the history after the mispredicted branch
                ghr <= train_history;
            end else if (predict_valid) begin
                // Update GHR by shifting in predicted taken bit
                ghr <= {ghr[5:0], predict_taken_comb};
            end
            // else hold GHR unchanged
        end
    end

endmodule