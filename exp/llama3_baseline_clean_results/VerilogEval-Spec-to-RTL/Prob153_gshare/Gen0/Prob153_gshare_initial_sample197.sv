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
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (train_taken) begin
                pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] + 1;
            end else begin
                pht[{train_pc[6:1], train_history[0]}] <= pht[{train_pc[6:1], train_history[0]}] - 1;
            end
            if (pht[{train_pc[6:1], train_history[0]}] < 0) begin
                pht[{train_pc[6:1], train_history[0]}] <= 0;
            end else if (pht[{train_pc[6:1], train_history[0]}] > 3) begin
                pht[{train_pc[6:1], train_history[0]}] <= 3;
            end
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
end

assign predict_taken = (pht[{predict_pc[6:1], global_history[0]}] >= 2);
assign predict_history = global_history;

endmodule