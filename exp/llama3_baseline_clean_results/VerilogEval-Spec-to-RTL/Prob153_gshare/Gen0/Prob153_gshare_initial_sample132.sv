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
    reg [1:0] pht [127:0];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            for (i = 0; i < 128; i++) begin
                pht[i] <= 2'b01;
            end
        end else begin
            if (train_valid) begin
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end
            if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
            if (train_valid) begin
                reg [6:0] index;
                index = train_pc ^ train_history;
                if (train_taken) begin
                    if (pht[index] < 2'b11) begin
                        pht[index] <= pht[index] + 1'b1;
                    end
                end else begin
                    if (pht[index] > 2'b00) begin
                        pht[index] <= pht[index] - 1'b1;
                    end
                end
            end
        end
    end

    always @(posedge clk) begin
        if (predict_valid) begin
            reg [6:0] index;
            index = predict_pc ^ global_history;
            predict_taken <= (pht[index] >= 2'b10);
            predict_history <= global_history;
        end
    end

endmodule