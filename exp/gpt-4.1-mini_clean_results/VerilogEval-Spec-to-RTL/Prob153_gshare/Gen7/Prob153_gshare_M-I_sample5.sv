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

    // PHT 2-bit saturating states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // 128-entry Pattern History Table (PHT)
    reg [1:0] pht [0:127];

    // Speculative global history register used for prediction and updated speculatively
    reg [6:0] ghr_spec;

    // Prediction index = PC XOR ghr_spec
    wire [6:0] predict_index = predict_pc ^ ghr_spec;

    // Training index = train_pc XOR train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Combinational read of PHT entries for prediction and training
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Next predicted taken bit from MSB of counter
    wire predict_taken_next = pht_predict_entry[1];

    // Registered outputs hold the prediction taken and history *before* GHR update
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Saturating counter increment
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    // Saturating counter decrement
    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    // Asynchronous reset for PHT with generate loop for synthesis friendliness
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : reset_pht_loop
            always @(posedge clk or posedge areset) begin
                if (areset) begin
                    pht[i] <= WN;
                end else if (train_valid && (train_index == i)) begin
                    // Update PHT entry on training
                    if (train_taken)
                        pht[i] <= saturate_inc(pht[i]);
                    else
                        pht[i] <= saturate_dec(pht[i]);
                end
            end
        end
    endgenerate

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_spec <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Register prediction outputs always each cycle
            // If predict_valid = 0, outputs hold last prediction
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_next;
                predict_history_reg <= ghr_spec; // history before speculative update
            end else begin
                // Hold previous values if no new prediction
                predict_taken_reg <= predict_taken_reg;
                predict_history_reg <= predict_history_reg;
            end

            // Update speculative GHR
            // Priority: if train_valid & train_mispredicted => restore ghr_spec from train_history
            // Else if predict_valid => shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                ghr_spec <= {ghr_spec[5:0], predict_taken_next};
            end
            // Else hold ghr_spec
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule