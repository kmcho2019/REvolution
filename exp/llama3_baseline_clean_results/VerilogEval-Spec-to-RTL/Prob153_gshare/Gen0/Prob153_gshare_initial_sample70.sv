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
    reg [1:0] pht [127:0];

    integer i;

    always @(*) begin
        predict_taken = 0;
        if (predict_valid) begin
            integer index = (predict_pc ^ global_history) % 128;
            if (pht[index] >= 2) begin
                predict_taken = 1;
            end
            predict_history = global_history;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 0;
            for (i = 0; i < 128; i++) begin
                pht[i] <= 0;
            end
        end else begin
            if (train_valid) begin
                integer index = (train_pc ^ train_history) % 128;
                if (train_taken) begin
                    if (pht[index] < 3) begin
                        pht[index] <= pht[index] + 1;
                    end
                end else begin
                    if (pht[index] > 0) begin
                        pht[index] <= pht[index] - 1;
                    end
                end
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end
            if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken};
            end
        end
    end

endmodule