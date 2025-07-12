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
reg [6:0] global_history_next;

reg [1:0] pht [0:127];
reg [1:0] pht_next [0:127];

assign predict_taken = (pht[{predict_pc[6:0], global_history[6:0]}[5:4] == 2'b11) ? 1'b1 : 1'b0;
assign predict_history = global_history;

always @(*) begin
    global_history_next = global_history;
    if (predict_valid && !areset) begin
        if (pht[{predict_pc[6:0], global_history[6:0]}[5:4] == 2'b11) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
    if (train_valid && train_mispredicted && !areset) begin
        global_history_next = train_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid && !areset) begin
            if (train_taken) begin
                if (pht[{train_pc[6:0], train_history[6:0]}[5:4]] != 2'b11) begin
                    pht[{train_pc[6:0], train_history[6:0]}[5:4]] <= pht[{train_pc[6:0], train_history[6:0]}[5:4]] + 1'b1;
                end
            end else begin
                if (pht[{train_pc[6:0], train_history[6:0]}[5:4]] != 2'b00) begin
                    pht[{train_pc[6:0], train_history[6:0]}[5:4]] <= pht[{train_pc[6:0], train_history[6:0]}[5:4]] - 1'b1;
                end
            end
        end
    end
end

endmodule