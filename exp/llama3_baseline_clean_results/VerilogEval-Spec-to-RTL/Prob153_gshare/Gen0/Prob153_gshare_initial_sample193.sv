module TopModule(
    input           clk,
    input           areset,

    input           predict_valid,
    input   [6:0]    predict_pc,
    output          predict_taken,
    output  [6:0]    predict_history,

    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input   [6:0]    train_history,
    input   [6:0]    train_pc
);

    reg [6:0] global_history;
    reg [6:0] global_history_next;

    reg [127:0][1:0] pht;
    reg [127:0][1:0] pht_next;

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
            for (i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            global_history <= global_history_next;
            pht <= pht_next;
        end
    end

    always @(*) begin
        global_history_next = global_history;
        pht_next = pht;

        if (train_valid) begin
            pht_next[{train_pc[6:1], train_history[0]}] = 
                (train_taken && train_mispredicted) ? 
                ((pht[{train_pc[6:1], train_history[0]}] == 2'b11) ? 
                 2'b11 : pht[{train_pc[6:1], train_history[0]}] + 1) :
                (!train_taken && train_mispredicted) ? 
                ((pht[{train_pc[6:1], train_history[0]}] == 2'b00) ? 
                 2'b00 : pht[{train_pc[6:1], train_history[0]}] - 1) :
                (train_taken && !train_mispredicted) ? 
                ((pht[{train_pc[6:1], train_history[0]}] == 2'b11) ? 
                 2'b11 : pht[{train_pc[6:1], train_history[0]}] + 1) :
                ((pht[{train_pc[6:1], train_history[0]}] == 2'b00) ? 
                 2'b00 : pht[{train_pc[6:1], train_history[0]}] - 1);

            if (train_mispredicted) begin
                global_history_next = train_history;
            end
        end else if (predict_valid) begin
            global_history_next = {global_history[5:0], predict_taken};
        end
    end

    always @(*) begin
        if (predict_valid) begin
            predict_taken = (pht[{predict_pc[6:1], global_history[0]}] >= 2'b10);
            predict_history = global_history;
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule