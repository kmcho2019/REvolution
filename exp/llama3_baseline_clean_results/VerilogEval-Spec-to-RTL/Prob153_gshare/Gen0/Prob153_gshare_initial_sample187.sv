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
reg [1:0] pht [127:0];

always @(*) begin
    if (predict_valid) begin
        predict_taken = (pht[(predict_pc ^ global_history) % 128] > 1);
        predict_history = global_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (train_taken) begin
                if (pht[(train_pc ^ train_history) % 128] < 3) begin
                    pht[(train_pc ^ train_history) % 128] <= pht[(train_pc ^ train_history) % 128] + 1;
                end
            end else begin
                if (pht[(train_pc ^ train_history) % 128] > 0) begin
                    pht[(train_pc ^ train_history) % 128] <= pht[(train_pc ^ train_history) % 128] - 1;
                end
            end
        end else if (predict_valid) begin
            if (predict_taken) begin
                global_history <= {global_history[5:0], 1'b1};
            end else begin
                global_history <= {global_history[5:0], 1'b0};
            end
        end
    end
end

endmodule