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
reg [127:0] [1:0] pht;

always @(*) begin
    predict_taken = (pht[{predict_pc, global_history} % 128] >= 2) ? 1 : 0;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= '{default: 2'b0};
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            pht[{train_pc, train_history} % 128] <= (pht[{train_pc, train_history} % 128] + (train_taken ? 2'b01 : 2'b11)) % 4;
        end
        if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
end

always @(*) begin
    predict_history = global_history;
end

endmodule