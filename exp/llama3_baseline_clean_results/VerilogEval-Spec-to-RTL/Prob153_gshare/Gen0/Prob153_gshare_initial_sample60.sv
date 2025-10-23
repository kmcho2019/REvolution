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
reg [1:0] saturating_counters [127:0];
reg [1:0] saturating_counters_next [127:0];

integer i;

always @(*) begin
    global_history_next = global_history;
    for (i = 0; i < 128; i++) begin
        saturating_counters_next[i] = saturating_counters[i];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (i = 0; i < 128; i++) begin
            saturating_counters[i] <= 2'b0;
        end
    end else begin
        global_history <= global_history_next;
        for (i = 0; i < 128; i++) begin
            saturating_counters[i] <= saturating_counters_next[i];
        end
    end
end

always @(*) begin
    predict_taken = 1'b0;
    predict_history = global_history;
    if (predict_valid) begin
        reg [6:0] index;
        index = predict_pc ^ global_history;
        if (saturating_counters[index] >= 2'b2) begin
            predict_taken = 1'b1;
        end
        global_history_next = {global_history[5:0], predict_taken};
    end
end

always @(*) begin
    if (train_valid) begin
        reg [6:0] index;
        index = train_pc ^ train_history;
        if (train_taken) begin
            if (saturating_counters[index] < 2'b3) begin
                saturating_counters_next[index] = saturating_counters[index] + 1;
            end
        end else begin
            if (saturating_counters[index] > 2'b0) begin
                saturating_counters_next[index] = saturating_counters[index] - 1;
            end
        end
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end
end

endmodule