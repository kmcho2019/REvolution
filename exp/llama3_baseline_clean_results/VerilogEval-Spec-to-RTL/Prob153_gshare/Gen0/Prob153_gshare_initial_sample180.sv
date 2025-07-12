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
reg [1:0] pht [0:127];

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
    end else begin
        global_history <= global_history_next;
        for (i = 0; i < 128; i++) begin
            if (train_valid && (train_pc ^ train_history) == i) begin
                if (train_taken && train_mispredicted) begin
                    if (pht[i] != 2'b11) begin
                        pht[i] <= pht[i] + 1'b1;
                    end
                end else if (!train_taken && train_mispredicted) begin
                    if (pht[i] != 2'b00) begin
                        pht[i] <= pht[i] - 1'b1;
                    end
                end else if (train_taken && !train_mispredicted) begin
                    if (pht[i] != 2'b11) begin
                        pht[i] <= pht[i] + 1'b1;
                    end
                end else if (!train_taken && !train_mispredicted) begin
                    if (pht[i] != 2'b00) begin
                        pht[i] <= pht[i] - 1'b1;
                    end
                end
            end
        end
    end
end

always @(*) begin
    global_history_next = global_history;
    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end else if (predict_valid) begin
        global_history_next = {global_history[5:0], predict_taken};
    end
end

always @(*) begin
    predict_taken = 1'b0;
    predict_history = global_history;
    if (predict_valid) begin
        predict_taken = (pht[predict_pc ^ global_history] == 2'b11 || pht[predict_pc ^ global_history] == 2'b10) ? 1'b1 : 1'b0;
    end
end

endmodule