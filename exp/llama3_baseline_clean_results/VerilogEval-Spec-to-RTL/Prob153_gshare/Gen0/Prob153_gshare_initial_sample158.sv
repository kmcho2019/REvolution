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
reg [127:0][1:0] pht;

always @(*) begin
    predict_taken = (pht[{predict_pc[6:1], global_history[6:1]}] >= 2'b10);
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            pht[{train_pc[6:1], train_history[6:1]}] <= (train_mispredicted && train_taken) ? (pht[{train_pc[6:1], train_history[6:1]}] == 2'b11) ? 2'b11 : (pht[{train_pc[6:1], train_history[6:1]}] + 1'b1) :
                (train_mispredicted && !train_taken) ? (pht[{train_pc[6:1], train_history[6:1]}] == 2'b00) ? 2'b00 : (pht[{train_pc[6:1], train_history[6:1]}] - 1'b1) :
                (pht[{train_pc[6:1], train_history[6:1]}]);
            if (train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end
end

always @(posedge clk) begin
    predict_history <= global_history;
end

endmodule