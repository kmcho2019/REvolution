module TopModule(
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] recover_history;
reg [127:0] [1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        recover_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= recover_history;
        end else begin
            global_history <= {global_history[5:0], train_taken};
        end
        if (predict_valid && (predict_pc ^ global_history) == (train_pc ^ train_history)) begin
            // prediction and training for the same PHT entry, do nothing
        end else begin
            pht[train_pc ^ train_history] <= (train_taken) ? (pht[train_pc ^ train_history] + 2'd1) : (pht[train_pc ^ train_history] - 2'd1);
            if (pht[train_pc ^ train_history] > 2'd3) begin
                pht[train_pc ^ train_history] <= 2'd3;
            end else if (pht[train_pc ^ train_history] < 0) begin
                pht[train_pc ^ train_history] <= 0;
            end
        end
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], 1'b1};
    end
end

assign predict_taken = (pht[predict_pc ^ global_history] > 1);
assign predict_history = global_history;

always @(posedge clk) begin
    recover_history <= global_history;
end

endmodule