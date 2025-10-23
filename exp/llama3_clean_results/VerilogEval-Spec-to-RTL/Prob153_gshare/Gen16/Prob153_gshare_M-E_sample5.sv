module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Gshare Predictor
reg [1:0] pht [127:0];
reg [6:0] gshare_history;

// Last-N-Branches (LNB) Predictor
localparam N = 8; // Number of last branches to track
reg [6:0] lnb_buffer [N-1:0]; // Buffer of last N branch pcs
reg [0:0] lnb_outcomes [N-1:0]; // Buffer of last N branch outcomes
reg [2:0] lnb_index; // Index into the LNB buffers

// History Management Unit (HMU)
always @(posedge clk) begin
    if (areset) begin
        gshare_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
        for (int i = 0; i < N; i++) begin
            lnb_buffer[i] <= 7'b0;
            lnb_outcomes[i] <= 1'b0;
        end
        lnb_index <= 3'b0;
    end else begin
        if (train_valid) begin
            // Update gshare history
            if (train_mispredicted) begin
                gshare_history <= train_history;
            end else if (train_taken) begin
                gshare_history <= {gshare_history[5:0], 1'b1};
            end else begin
                gshare_history <= {gshare_history[5:0], 1'b0};
            end

            // Update PHT
            if (train_taken) begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b11)? 2'b11 : pht[train_pc ^ train_history] + 1;
            end else begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'b00)? 2'b00 : pht[train_pc ^ train_history] - 1;
            end

            // Update LNB predictor
            for (int i = 0; i < N; i++) begin
                if (lnb_buffer[i] == train_pc) begin
                    lnb_outcomes[i] <= train_taken;
                end
            end
            // Shift LNB buffers
            for (int i = N-2; i >= 0; i--) begin
                lnb_buffer[i+1] <= lnb_buffer[i];
                lnb_outcomes[i+1] <= lnb_outcomes[i];
            end
            lnb_buffer[0] <= train_pc;
            lnb_outcomes[0] <= train_taken;
        end else if (predict_valid) begin
            // Predict using gshare and bias with LNB
            reg [1:0] gshare_pred;
            gshare_pred = pht[predict_pc ^ gshare_history];
            reg predict_bias;
            predict_bias = 1'b0;
            for (int i = 0; i < N; i++) begin
                if (lnb_buffer[i] == predict_pc) begin
                    predict_bias = lnb_outcomes[i];
                    break;
                end
            end
            if (predict_bias) begin
                predict_taken <= (gshare_pred >= 2'b10);
            end else begin
                predict_taken <= (gshare_pred > 2'b01);
            end
            predict_history <= gshare_history;

            // Update gshare history for next prediction
            if (predict_taken) begin
                gshare_history <= {gshare_history[5:0], 1'b1};
            end else begin
                gshare_history <= {gshare_history[5:0], 1'b0};
            end
        end
    end
end

endmodule