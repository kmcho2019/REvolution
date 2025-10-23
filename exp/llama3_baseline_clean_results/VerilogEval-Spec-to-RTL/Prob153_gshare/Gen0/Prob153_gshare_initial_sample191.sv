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

reg [7:0] pht [127:0];

always @(*) begin
    global_history_next = global_history;
    if (predict_valid && ~areset) begin
        if (train_mispredicted && train_valid && ~areset) begin
            global_history_next = train_history;
        end else begin
            global_history_next = {global_history[5:0], predict_taken};
        end
    end else if (areset) begin
        global_history_next = 7'd0;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid && ~areset) begin
            reg [6:0] index;
            index = train_pc ^ train_history;
            if (train_taken) begin
                if (pht[index] < 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                if (pht[index] > 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = predict_pc ^ global_history;
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = global_history;
end

endmodule