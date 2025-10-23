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
reg [6:0] recover_history;
reg [1:0] gshare_cache [127:0];
reg [1:0] bimodal_cache [127:0];

wire [6:0] predict_gshare_index;
wire [6:0] predict_bimodal_index;
wire [6:0] train_gshare_index;
wire [6:0] train_bimodal_index;

assign predict_gshare_index = predict_pc ^ global_history;
assign predict_bimodal_index = predict_pc;
assign train_gshare_index = train_pc ^ train_history;
assign train_bimodal_index = train_pc;

reg gshare_confidence;
reg bimodal_confidence;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        recover_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        gshare_confidence <= 1'b0;
        bimodal_confidence <= 1'b0;
        for (int i = 0; i < 128; i++) begin
            gshare_cache[i] <= 2'b00;
            bimodal_cache[i] <= 2'b00;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                recover_history <= train_history;
            end else if (!predict_valid || train_gshare_index != predict_gshare_index) begin
                if (train_taken) begin
                    recover_history <= {global_history[5:0], 1'b1};
                end else begin
                    recover_history <= {global_history[5:0], 1'b0};
                end
            end

            if (train_taken) begin
                if (gshare_cache[train_gshare_index] == 2'b00) begin
                    gshare_cache[train_gshare_index] <= 2'b01;
                end else if (gshare_cache[train_gshare_index] == 2'b01) begin
                    gshare_cache[train_gshare_index] <= 2'b11;
                end

                if (bimodal_cache[train_bimodal_index] == 2'b00) begin
                    bimodal_cache[train_bimodal_index] <= 2'b01;
                end else if (bimodal_cache[train_bimodal_index] == 2'b01) begin
                    bimodal_cache[train_bimodal_index] <= 2'b11;
                end
            end else begin
                if (gshare_cache[train_gshare_index] == 2'b11) begin
                    gshare_cache[train_gshare_index] <= 2'b10;
                end else if (gshare_cache[train_gshare_index] == 2'b10) begin
                    gshare_cache[train_gshare_index] <= 2'b00;
                end

                if (bimodal_cache[train_bimodal_index] == 2'b11) begin
                    bimodal_cache[train_bimodal_index] <= 2'b10;
                end else if (bimodal_cache[train_bimodal_index] == 2'b10) begin
                    bimodal_cache[train_bimodal_index] <= 2'b00;
                end
            end
        end else if (predict_valid) begin
            gshare_confidence <= (gshare_cache[predict_gshare_index] == 2'b11 || gshare_cache[predict_gshare_index] == 2'b10);
            bimodal_confidence <= (bimodal_cache[predict_bimodal_index] == 2'b11 || bimodal_cache[predict_bimodal_index] == 2'b10);

            if (gshare_confidence && !bimodal_confidence) begin
                predict_taken <= gshare_confidence;
            end else if (bimodal_confidence && !gshare_confidence) begin
                predict_taken <= bimodal_confidence;
            end else begin
                predict_taken <= gshare_confidence;
            end

            predict_history <= global_history;
        end

        global_history <= recover_history;
    end
end

endmodule