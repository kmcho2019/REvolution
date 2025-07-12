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

// Gshare predictor
reg [1:0] gshare_pht [127:0];
reg [6:0] gshare_history;

// Bimodal predictor
reg [1:0] bimodal_pht [127:0];

// Hybrid predictor
reg [6:0] history;
reg predict_confidence;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b0;
            bimodal_pht[i] <= 2'b0;
        end
    end else begin
        // Prediction logic
        if (predict_valid) begin
            reg [6:0] gshare_index = predict_pc ^ gshare_history;
            reg [6:0] bimodal_index = predict_pc;
            predict_confidence = (gshare_pht[gshare_index] >= 2'b10);
            predict_taken <= (predict_confidence) ? (gshare_pht[gshare_index] >= 2'b10) : (bimodal_pht[bimodal_index] >= 2'b10);
            predict_history <= history;
        end

        // Training logic
        if (train_valid) begin
            reg [6:0] gshare_index = train_pc ^ train_history;
            reg [6:0] bimodal_index = train_pc;
            if (train_taken) begin
                gshare_pht[gshare_index] <= (gshare_pht[gshare_index] == 2'b11)? 2'b11 : gshare_pht[gshare_index] + 1;
                bimodal_pht[bimodal_index] <= (bimodal_pht[bimodal_index] == 2'b11)? 2'b11 : bimodal_pht[bimodal_index] + 1;
            end else begin
                gshare_pht[gshare_index] <= (gshare_pht[gshare_index] == 2'b00)? 2'b00 : gshare_pht[gshare_index] - 1;
                bimodal_pht[bimodal_index] <= (bimodal_pht[bimodal_index] == 2'b00)? 2'b00 : bimodal_pht[bimodal_index] - 1;
            end
        end

        // History update logic
        if (train_mispredicted && train_valid) begin
            history <= train_history;
        end else if (predict_valid) begin
            history <= {history[5:0], predict_taken};
            gshare_history <= {gshare_history[5:0], predict_taken};
        end
    end
end

endmodule