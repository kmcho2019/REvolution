module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] global_history_next;
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= train_history;
        end else begin
            global_history <= {global_history[5:0], train_taken};
        end
        pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] <=
            (train_taken && train_mispredicted) ? (pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] == 2'b11) ? 2'b11 : pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] + 1 :
            (!train_taken && train_mispredicted) ? (pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] == 2'b00) ? 2'b00 : pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] - 1 :
            (pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] == 2'b11) ? 2'b11 : pht[{train_pc[6:2], train_history[6:2]} ^ {global_history[6:2]}] + 1;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end
end

assign predict_taken = (pht[{predict_pc[6:2], global_history[6:2]} ^ {global_history[6:2]}] >= 2'b10);
assign predict_history = global_history;

endmodule