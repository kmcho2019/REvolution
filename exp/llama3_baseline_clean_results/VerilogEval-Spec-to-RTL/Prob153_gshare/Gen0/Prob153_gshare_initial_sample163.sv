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
reg [6:0] index;
reg [6:0] index_next;

assign predict_taken = (pht[index] > 1);
assign predict_history = global_history;

always @(*) begin
    global_history_next = global_history;
    index_next = {7{1'b0}};

    if (predict_valid) begin
        index_next = predict_pc ^ global_history;
        if (predict_taken)
            global_history_next = {global_history[5:0], 1'b1};
        else
            global_history_next = {global_history[5:0], 1'b0};
    end

    if (train_valid) begin
        index_next = train_pc ^ train_history;
        if (train_mispredicted)
            global_history_next = train_history;
        if (train_taken) begin
            if (pht[index_next] < 2)
                pht[index_next] <= pht[index_next] + 1;
        end else begin
            if (pht[index_next] > 0)
                pht[index_next] <= pht[index_next] - 1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= {7{1'b0}};
        for (int i = 0; i < 128; i++)
            pht[i] <= 2;
    end else begin
        global_history <= global_history_next;
        // training updates pht at the next positive clock edge
        for (int i = 0; i < 128; i++)
            pht[i] <= pht[i];
    end
end

endmodule