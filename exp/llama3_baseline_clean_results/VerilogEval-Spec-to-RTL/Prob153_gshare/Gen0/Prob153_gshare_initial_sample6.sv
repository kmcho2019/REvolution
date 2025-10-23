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
    reg [1:0] pht [127:0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
        end else begin
            global_history <= global_history_next;
        end
    end

    always @(*) begin
        global_history_next = global_history;
        if (predict_valid) begin
            if (pht[{predict_pc[6:1], predict_pc[0] ^ global_history}] == 2'b11) begin
                predict_taken = 1'b1;
                global_history_next = {global_history[5:0], 1'b1};
            end else if (pht[{predict_pc[6:1], predict_pc[0] ^ global_history}] == 2'b00) begin
                predict_taken = 1'b0;
                global_history_next = {global_history[5:0], 1'b0};
            end else begin
                predict_taken = 1'b1;
                global_history_next = {global_history[5:0], 1'b1};
            end
        end
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history_next = train_history;
            end
            if (pht[{train_pc[6:1], train_pc[0] ^ train_history}] == 2'b00 && train_taken) begin
                pht[{train_pc[6:1], train_pc[0] ^ train_history}] <= 2'b01;
            end else if (pht[{train_pc[6:1], train_pc[0] ^ train_history}] == 2'b11 && !train_taken) begin
                pht[{train_pc[6:1], train_pc[0] ^ train_history}] <= 2'b10;
            end else if (pht[{train_pc[6:1], train_pc[0] ^ train_history}] == 2'b01 && train_taken) begin
                pht[{train_pc[6:1], train_pc[0] ^ train_history}] <= 2'b11;
            end else if (pht[{train_pc[6:1], train_pc[0] ^ train_history}] == 2'b10 && !train_taken) begin
                pht[{train_pc[6:1], train_pc[0] ^ train_history}] <= 2'b00;
            end
        end
    end

    assign predict_history = global_history;

    initial begin
        for (int i = 0; i < 128; i++) begin
            pht[i] = 2'b01;
        end
    end

endmodule