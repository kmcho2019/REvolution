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

reg [6:0] history;
reg [6:0] next_history;

reg [7:0] pht [127:0];

always @(*) begin
    next_history = history;
    if (predict_valid) begin
        if (history[6] ^ predict_pc[6]) begin
            next_history[6] = 1'b1;
        end else begin
            next_history[6] = 1'b0;
        end
        for (int i = 5; i >= 0; i--) begin
            next_history[i] = history[i + 1];
        end
    end
    if (train_valid && train_mispredicted) begin
        next_history = train_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        history <= next_history;
        if (train_valid) begin
            reg [6:0] index;
            index = predict_pc ^ history;
            case (pht[index[6:0]])
                2'b00: pht[index[6:0]] <= train_taken ? 2'b01 : 2'b00;
                2'b01: pht[index[6:0]] <= train_taken ? 2'b10 : 2'b00;
                2'b10: pht[index[6:0]] <= train_taken ? 2'b11 : 2'b01;
                2'b11: pht[index[6:0]] <= train_taken ? 2'b11 : 2'b10;
            endcase
        end
    end
end

reg [6:0] index;
assign index = predict_pc ^ history;

assign predict_taken = (pht[index[6:0]] > 2'b01);
assign predict_history = history;

endmodule