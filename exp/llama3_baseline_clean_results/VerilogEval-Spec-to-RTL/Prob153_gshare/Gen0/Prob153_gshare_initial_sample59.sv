module TopModule(
    input           clk,
    input           areset,
    input           predict_valid,
    input   [6:0]   predict_pc,
    output          predict_taken,
    output  [6:0]   predict_history,
    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input   [6:0]   train_history,
    input   [6:0]   train_pc
);

reg [6:0] global_history;
reg [7:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
        end
        if (train_valid) begin
            reg [6:0] index;
            index = (train_history ^ train_pc)[6:0];
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
end

always @(*) begin
    reg [6:0] index;
    index = (global_history ^ predict_pc)[6:0];
    predict_history = global_history;
    if (pht[index] >= 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
end

endmodule