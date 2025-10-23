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

    reg [6:0] bhr;
    reg [6:0] bhr_next;
    reg [1:0] pht [127:0];
    reg [6:0] pht_index;
    reg predict_taken_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            bhr <= 7'b0;
        end else if (train_valid && train_mispredicted) begin
            bhr <= train_history;
        end else if (predict_valid) begin
            bhr <= bhr_next;
        end
    end

    always @(*) begin
        pht_index = predict_pc[6:0] ^ bhr;
        predict_taken_reg = (pht[pht_index] >= 2'b2) ? 1'b1 : 1'b0;
        predict_history = bhr;
        bhr_next = bhr;
        if (predict_valid && predict_taken_reg) begin
            bhr_next = {bhr[5:0], 1'b1};
        end else if (predict_valid && !predict_taken_reg) begin
            bhr_next = {bhr[5:0], 1'b0};
        end
    end

    always @(posedge clk) begin
        if (train_valid) begin
            if (train_taken && train_pc[6:0] ^ train_history == pht_index) begin
                if (pht[pht_index] != 2'b3) begin
                    pht[pht_index] <= pht[pht_index] + 1'b1;
                end
            end else if (!train_taken && train_pc[6:0] ^ train_history == pht_index) begin
                if (pht[pht_index] != 2'b0) begin
                    pht[pht_index] <= pht[pht_index] - 1'b1;
                end
            end
        end
    end

    assign predict_taken = predict_taken_reg;

endmodule