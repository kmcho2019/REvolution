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
    reg [1:0] pht_next [127:0];

    assign predict_taken = (pht[{predict_pc[6:1], global_history[6:1]}] > 1'b1);
    assign predict_history = global_history;

    always @(*) begin
        global_history_next = global_history;
        for (int i = 0; i < 128; i++) begin
            pht_next[i] = pht[i];
        end

        if (train_valid) begin
            if (train_taken) begin
                if (pht[{train_pc[6:1], train_history[6:1]}] < 2'd3) begin
                    pht_next[{train_pc[6:1], train_history[6:1]}]++;
                end
            end else begin
                if (pht[{train_pc[6:1], train_history[6:1]}] > 2'd0) begin
                    pht_next[{train_pc[6:1], train_history[6:1]}]--;
                end
            end

            if (train_mispredicted) begin
                global_history_next = train_history;
            end
        end

        if (predict_valid && !train_mispredicted) begin
            if (predict_taken) begin
                global_history_next = {global_history[5:0], 1'b1};
            end else begin
                global_history_next = {global_history[5:0], 1'b0};
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b1;
            end
        end else begin
            global_history <= global_history_next;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= pht_next[i];
            end
        end
    end

endmodule