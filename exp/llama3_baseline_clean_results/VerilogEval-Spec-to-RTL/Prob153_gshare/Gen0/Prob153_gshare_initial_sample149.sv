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

reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

wire [6:0] index;
assign index = {predict_pc[6:1], predict_pc[0] ^ global_history[0]};

always @(*) begin
    global_history_next = global_history;
    if (train_valid && train_mispredicted) begin
        global_history_next = train_history;
    end else if (predict_valid) begin
        if (pht[index] == 2'b11 || pht[index] == 2'b10) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else if (pht[index] == 2'b01 || pht[index] == 2'b00) begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end
end

assign predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
assign predict_history = global_history;

always @(*) begin
    pht_next = pht;
    if (train_valid) begin
        wire [6:0] train_index;
        assign train_index = {train_pc[6:1], train_pc[0] ^ train_history[0]};
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht_next[train_index] = pht[train_index] + 1'b1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht_next[train_index] = pht[train_index] - 1'b1;
            end
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

endmodule