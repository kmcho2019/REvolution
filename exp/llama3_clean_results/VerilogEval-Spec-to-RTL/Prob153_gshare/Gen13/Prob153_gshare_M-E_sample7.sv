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

reg [6:0] global_history;
reg [1:0] gshare_cache [127:0];
reg [1:0] bimodal_cache [127:0];
reg [1:0] meta_predictor_counters [1:0];

wire [6:0] gshare_index;
wire [6:0] bimodal_index;

assign gshare_index = predict_pc ^ global_history;
assign bimodal_index = predict_pc;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_cache[i] <= 2'b00;
            bimodal_cache[i] <= 2'b00;
        end
        meta_predictor_counters[0] <= 2'b00;
        meta_predictor_counters[1] <= 2'b00;
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (gshare_cache[train_pc ^ train_history]!= 2'b11) begin
                    gshare_cache[train_pc ^ train_history] <= gshare_cache[train_pc ^ train_history] + 1'b1;
                end
                if (bimodal_cache[train_pc]!= 2'b11) begin
                    bimodal_cache[train_pc] <= bimodal_cache[train_pc] + 1'b1;
                end
            end else begin
                if (gshare_cache[train_pc ^ train_history]!= 2'b00) begin
                    gshare_cache[train_pc ^ train_history] <= gshare_cache[train_pc ^ train_history] - 1'b1;
                end
                if (bimodal_cache[train_pc]!= 2'b00) begin
                    bimodal_cache[train_pc] <= bimodal_cache[train_pc] - 1'b1;
                end
            end
            
            if (train_mispredicted) begin
                global_history <= train_history;
            end
        end
        
        if (predict_valid) begin
            reg gshare_prediction;
            reg bimodal_prediction;
            reg final_prediction;
            
            gshare_prediction <= (gshare_cache[gshare_index] == 2'b11 || gshare_cache[gshare_index] == 2'b10);
            bimodal_prediction <= (bimodal_cache[bimodal_index] == 2'b11 || bimodal_cache[bimodal_index] == 2'b10);
            
            if (meta_predictor_counters[0] > meta_predictor_counters[1]) begin
                final_prediction <= gshare_prediction;
            end else begin
                final_prediction <= bimodal_prediction;
            end
            
            predict_taken <= final_prediction;
            predict_history <= global_history;
            
            if (!train_valid || (train_valid &&!train_mispredicted)) begin
                if (final_prediction) begin
                    global_history <= {global_history[5:0], 1'b1};
                end else begin
                    global_history <= {global_history[5:0], 1'b0};
                end
            end
            
            if (gshare_prediction == final_prediction) begin
                meta_predictor_counters[0] <= meta_predictor_counters[0] + 1'b1;
            end else begin
                meta_predictor_counters[1] <= meta_predictor_counters[1] + 1'b1;
            end
        end
    end
end

endmodule