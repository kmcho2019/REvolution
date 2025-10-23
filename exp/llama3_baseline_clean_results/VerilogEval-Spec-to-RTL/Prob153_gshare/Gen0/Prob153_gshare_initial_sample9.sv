module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    reg [6:0] global_history;
    reg [6:0] global_history_next;
    reg [6:0] recover_history;

    wire [6:0] index;
    wire [1:0] saturating_counter;
    wire predict_taken_comb;

    reg [7:0] saturating_counter_table [127:0];

    assign index = predict_pc[6:0] ^ global_history;
    assign predict_taken_comb = (saturating_counter == 2'b11 || saturating_counter == 2'b10);

    always @(*) begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history_next = train_history;
            end else if (train_taken) begin
                global_history_next = {train_history[5:0], 1'b1};
            end else begin
                global_history_next = {train_history[5:0], 1'b0};
            end
        end else if (predict_valid) begin
            if (predict_taken_comb) begin
                global_history_next = {global_history[5:0], 1'b1};
            end else begin
                global_history_next = {global_history[5:0], 1'b0};
            end
        end else begin
            global_history_next = global_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                saturating_counter_table[i] <= 2'b01;
            end
        end else begin
            global_history <= global_history_next;
            if (train_valid) begin
                if (train_mispredicted) begin
                    if (train_taken) begin
                        saturating_counter_table[train_pc[6:0] ^ train_history] <= saturating_counter_table[train_pc[6:0] ^ train_history] + 2'b01;
                    end else begin
                        saturating_counter_table[train_pc[6:0] ^ train_history] <= saturating_counter_table[train_pc[6:0] ^ train_history] - 2'b01;
                    end
                end else if (train_taken) begin
                    saturating_counter_table[train_pc[6:0] ^ train_history] <= saturating_counter_table[train_pc[6:0] ^ train_history] + 2'b01;
                end else begin
                    saturating_counter_table[train_pc[6:0] ^ train_history] <= saturating_counter_table[train_pc[6:0] ^ train_history] - 2'b01;
                end
                saturating_counter_table[train_pc[6:0] ^ train_history] <= (saturating_counter_table[train_pc[6:0] ^ train_history] > 2'b11) ? 2'b11 : (saturating_counter_table[train_pc[6:0] ^ train_history] < 2'b00) ? 2'b00 : saturating_counter_table[train_pc[6:0] ^ train_history];
            end
        end
    end

    assign predict_taken = predict_taken_comb;
    assign predict_history = global_history;
    assign saturating_counter = saturating_counter_table[index];

endmodule