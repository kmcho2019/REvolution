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
reg [1:0] pht [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        if (predict_valid) begin
            predict_taken <= (pht[predict_index] >= 2'b10)? 1'b1 : 1'b0;
            predict_history <= global_history;
            global_history <= {global_history[5:0], predict_taken};
        end

        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (pht[train_index] == 2'b00 && ~train_taken) begin
                pht[train_index] <= 2'b01;
            end else if (pht[train_index] == 2'b11 && train_taken) begin
                pht[train_index] <= 2'b10;
            end else if (~train_taken) begin
                pht[train_index] <= pht[train_index] - 1'b1;
            end else begin
                pht[train_index] <= pht[train_index] + 1'b1;
            end
        end
    end
end

endmodule