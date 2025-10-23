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

reg [6:0] pht_index;
reg [1:0] pht_value;
reg [1:0] next_pht_value;

reg predict_taken_reg;

reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                history <= train_history;
            end else begin
                history <= {history[5:0], train_taken};
            end
            pht_index <= {predict_pc[6:1], history[0]};
            next_pht_value <= pht[pht_index];
            if (train_taken) begin
                if (next_pht_value == 2'b11) begin
                    next_pht_value <= 2'b11;
                end else begin
                    next_pht_value <= next_pht_value + 1;
                end
            end else begin
                if (next_pht_value == 2'b00) begin
                    next_pht_value <= 2'b00;
                end else begin
                    next_pht_value <= next_pht_value - 1;
                end
            end
        end else if (predict_valid) begin
            history <= {history[5:0], predict_taken_reg};
        end
        pht[pht_index] <= next_pht_value;
    end
end

always @(*) begin
    pht_index = {predict_pc[6:1], history[0]};
    pht_value = pht[pht_index];
    predict_taken_reg = (pht_value == 2'b11 || pht_value == 2'b10);
    predict_history = history;
    next_pht_value = pht_value;
end

assign predict_taken = predict_taken_reg;

endmodule