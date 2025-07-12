module TopModule (
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
reg [6:0] pht_index;
reg [1:0] pht_entry;

reg [6:0] next_global_history;
reg [1:0] next_pht_entry;

reg [127:0] [1:0] pht;

always @(*) begin
    pht_index = global_history ^ predict_pc;
    pht_entry = pht[pht_index];
    predict_taken = (pht_entry == 2'b11 || pht_entry == 2'b10);
    predict_history = global_history;
end

always @(*) begin
    if (train_valid && train_mispredicted) begin
        next_global_history = train_history;
    end else if (predict_valid) begin
        next_global_history = global_history;
        if (predict_taken) begin
            next_global_history = {next_global_history[5:0], 1'b1};
        end else begin
            next_global_history = {next_global_history[5:0], 1'b0};
        end
    end else begin
        next_global_history = global_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        global_history <= next_global_history;
        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc ^ train_history] == 2'b00) begin
                    pht[train_pc ^ train_history] <= 2'b01;
                end else if (pht[train_pc ^ train_history] == 2'b01) begin
                    pht[train_pc ^ train_history] <= 2'b10;
                end else if (pht[train_pc ^ train_history] == 2'b10) begin
                    pht[train_pc ^ train_history] <= 2'b11;
                end
            end else begin
                if (pht[train_pc ^ train_history] == 2'b11) begin
                    pht[train_pc ^ train_history] <= 2'b10;
                end else if (pht[train_pc ^ train_history] == 2'b10) begin
                    pht[train_pc ^ train_history] <= 2'b01;
                end else if (pht[train_pc ^ train_history] == 2'b01) begin
                    pht[train_pc ^ train_history] <= 2'b00;
                end
            end
        end
    end
end

endmodule