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

reg [6:0] gbhr;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            gbhr <= train_history;
        end else if (predict_valid && !train_valid) begin
            if (pht[predict_pc ^ gbhr] >= 2'd2) begin
                gbhr <= {gbhr[5:0], 1'b1};
            end else begin
                gbhr <= {gbhr[5:0], 1'b0};
            end
        end

        if (train_valid) begin
            if (train_taken) begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'd3) ? 2'd3 : pht[train_pc ^ train_history] + 1;
            end else begin
                pht[train_pc ^ train_history] <= (pht[train_pc ^ train_history] == 2'd0) ? 2'd0 : pht[train_pc ^ train_history] - 1;
            end
        end
    end
end

always @(*) begin
    predict_taken = (pht[predict_pc ^ gbhr] >= 2'd2) ? 1'b1 : 1'b0;
    predict_history = gbhr;
end

endmodule