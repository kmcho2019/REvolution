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

    // PHT states encoding (2-bit saturating counter)
    localparam STRONG_NOT_TAKEN = 2'b00;
    localparam WEAK_NOT_TAKEN   = 2'b01;
    localparam WEAK_TAKEN       = 2'b10;
    localparam STRONG_TAKEN     = 2'b11;

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers
    reg [6:0] ghr_shadow; // committed history (updated on training non-mispredict)
    reg [6:0] ghr_spec;   // speculative history (used for prediction, updated on prediction and mispredict recovery)

    // Indexes for combinational reads
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire predict_taken_comb = pht_predict_entry[1]; // MSB is taken prediction bit

    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    // Saturating counter update functions
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case (val)
                STRONG_TAKEN: saturate_inc = STRONG_TAKEN;
                default:      saturate_inc = val + 2'b01;
            endcase
        end
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        begin
            case (val)
                STRONG_NOT_TAKEN: saturate_dec = STRONG_NOT_TAKEN;
                default:           saturate_dec = val - 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Asynchronous reset and sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_shadow <= 7'b0;
            ghr_spec <= 7'b0;
            // Initialize all PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WEAK_NOT_TAKEN;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train_entry);
                else
                    pht[train_index] <= saturate_dec(pht_train_entry);
            end

            // Update ghr_shadow: committed history updated only on train_valid & no mispredict
            if (train_valid && !train_mispredicted) begin
                ghr_shadow <= {ghr_shadow[5:0], train_taken};
            end

            // Update ghr_spec (speculative history)
            if (train_valid && train_mispredicted) begin
                // On misprediction, restore speculative history to train_history (recovery)
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // On prediction, shift in predicted bit
                ghr_spec <= {ghr_spec[5:0], predict_taken_comb};
            end
            // Else hold current ghr_spec
        end
    end

    // Outputs combinationally reflect the prediction results at cycle start
    assign predict_taken = predict_taken_comb;
    assign predict_history = ghr_spec;

endmodule