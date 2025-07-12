module TopModule(
    input               clk,
    input               areset,

    input               predict_valid,
    input   [6:0]       predict_pc,
    output              predict_taken,
    output  [6:0]       predict_history,

    input               train_valid,
    input               train_taken,
    input               train_mispredicted,
    input   [6:0]       train_history,
    input   [6:0]       train_pc
);

reg [6:0] history_reg;
reg [6:0] history_reg_next;

reg [7:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_reg <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid && train_mispredicted) begin
        history_reg <= train_history;
    end else if (predict_valid) begin
        history_reg <= (history_reg << 1) | predict_taken;
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        reg [6:0] index;
        index = (predict_pc ^ history_reg)[6:0];
        if (index >= 128) begin
            index = 127;
        end
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                pht[index] <= pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                pht[index] <= pht[index] - 1'b1;
            end
        end
    end
end

always @(*) begin
    reg [6:0] index;
    index = (predict_pc ^ history_reg)[6:0];
    if (index >= 128) begin
        index = 127;
    end
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = history_reg;
end

endmodule