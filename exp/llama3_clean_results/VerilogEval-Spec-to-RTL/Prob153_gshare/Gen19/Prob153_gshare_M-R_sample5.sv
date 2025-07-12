module GsharePredictor(
    input [6:0] predict_pc,
    input [6:0] gshare_history,
    output reg predict_taken,
    output reg [6:0] predict_history
);

reg [1:0] gshare_pht [127:0];
reg [6:0] gshare_index;

assign gshare_index = predict_pc ^ gshare_history;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_pht[i] <= 2'b0;
        end
    end else begin
        predict_taken <= (gshare_pht[gshare_index] >= 2'b10);
        predict_history <= {gshare_history[5:0], predict_taken};
    end
end

endmodule

module BimodalPredictor(
    input [6:0] predict_pc,
    output reg predict_taken
);

reg [1:0] bimodal_pht [127:0];
reg [6:0] bimodal_index;

assign bimodal_index = predict_pc;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        predict_taken <= 1'b0;
        for (int i = 0; i < 128; i++) begin
            bimodal_pht[i] <= 2'b0;
        end
    end else begin
        predict_taken <= (bimodal_pht[bimodal_index] >= 2'b10);
    end
end

endmodule

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

wire gshare_predict_taken;
wire [6:0] gshare_predict_history;
wire bimodal_predict_taken;

GsharePredictor gshare_predictor(
   .predict_pc(predict_pc),
   .gshare_history(gshare_predict_history),
   .predict_taken(gshare_predict_taken),
   .predict_history(gshare_predict_history)
);

BimodalPredictor bimodal_predictor(
   .predict_pc(predict_pc),
   .predict_taken(bimodal_predict_taken)
);

reg [6:0] gshare_history;
reg [6:0] history;

always @(posedge clk or negedge areset) begin
    if (~areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        gshare_history <= 7'b0;
        history <= 7'b0;
    end else begin
        // Prediction logic
        if (predict_valid) begin
            predict_taken <= (gshare_predict_taken)? gshare_predict_taken : bimodal_predict_taken;
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
            gshare_history <= train_history;
        end else if (predict_valid) begin
            history <= {history[5:0], predict_taken};
            gshare_history <= {gshare_history[5:0], predict_taken};
        end
    end
end

endmodule