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
reg [7:0] index;
reg [1:0] counter;
reg [1:0] counter_next;
reg predict_taken_next;
reg [6:0] predict_history_next;
reg [6:0] train_history_reg;

always @(*) begin
    global_history_next = global_history;
    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end else if (predict_valid) begin
        global_history_next = {global_history[5:0], predict_taken_next};
    end
end

always @(*) begin
    index = predict_pc ^ global_history;
    counter = counter_table[index];
    predict_taken_next = (counter[1] || counter[0]);
end

always @(*) begin
    predict_history_next = global_history;
end

always @(*) begin
    counter_next = counter;
    if (train_valid) begin
        if (train_taken && counter < 2'b11) begin
            counter_next = counter + 1'b1;
        end else if (!train_taken && counter > 2'b00) begin
            counter_next = counter - 1'b1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            counter_table[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            counter_table[index] <= counter_next;
        end
    end
end

assign predict_taken = predict_taken_next;
assign predict_history = predict_history_next;

reg [1:0] counter_table [0:127];

endmodule