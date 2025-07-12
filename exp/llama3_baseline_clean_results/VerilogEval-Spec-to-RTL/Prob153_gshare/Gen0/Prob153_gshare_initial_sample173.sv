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
    reg [7:0] index_train;
    reg [1:0] counter;
    reg [1:0] counter_train;
    reg [1:0] counter_next;
    reg predict_taken_reg;

    // Pattern History Table (PHT)
    reg [1:0] pht [127:0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            global_history <= global_history_next;
            for (int i = 0; i < 128; i++) begin
                if (index_train == i) begin
                    pht[i] <= counter_next;
                end
            end
        end
    end

    always @(*) begin
        global_history_next = global_history;
        if (predict_valid) begin
            if (predict_taken_reg) begin
                global_history_next = {global_history[5:0], 1'b1};
            end else begin
                global_history_next = {global_history[5:0], 1'b0};
            end
        end
        if (train_valid && train_mispredicted) begin
            global_history_next = train_history;
        end
    end

    always @(*) begin
        index = predict_pc ^ global_history;
        index_train = train_pc ^ train_history;
        counter = pht[index];
        counter_train = pht[index_train];
    end

    always @(*) begin
        counter_next = counter_train;
        if (train_valid) begin
            if (train_taken) begin
                if (counter_train == 2'b11) begin
                    counter_next = counter_train;
                end else begin
                    counter_next = counter_train + 1;
                end
            end else begin
                if (counter_train == 2'b00) begin
                    counter_next = counter_train;
                end else begin
                    counter_next = counter_train - 1;
                end
            end
        end
    end

    always @(*) begin
        predict_taken_reg = (counter[1] == 1'b1);
        predict_taken = predict_taken_reg;
        predict_history = global_history;
    end

endmodule