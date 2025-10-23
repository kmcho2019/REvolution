module TopModule (
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
reg [127:0] pht [1:0]; // 128-entry table of two-bit saturating counters

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= global_history_next;
    end
end

always @(*) begin
    global_history_next = global_history;
    if (predict_valid && predict_taken) begin
        global_history_next = {global_history[5:0], 1'b1};
    end else if (predict_valid && !predict_taken) begin
        global_history_next = {global_history[5:0], 1'b0};
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else if (train_valid) begin
        reg [6:0] index;
        index = (predict_pc ^ global_history);
        if (index >= 128) begin
            index = 127;
        end
        if (train_taken) begin
            if (pht[index] < 2'd3) begin
                pht[index] <= pht[index] + 1'd1;
            end
        end else begin
            if (pht[index] > 2'd0) begin
                pht[index] <= pht[index] - 1'd1;
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = (predict_pc ^ global_history);
    if (index >= 128) begin
        index = 127;
    end
    if (pht[index] >= 2'd2) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = global_history;
end

endmodule