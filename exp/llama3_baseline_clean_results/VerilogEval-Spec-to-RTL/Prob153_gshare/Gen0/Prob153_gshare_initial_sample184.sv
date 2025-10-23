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

reg predict_taken_reg;
reg [6:0] predict_history_reg;

integer i;
reg [6:0] index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else if (predict_valid) begin
        index <= (predict_pc ^ global_history) % 128;
        if (pht[index] >= 2'b2) begin
            predict_taken_reg <= 1'b1;
        end else begin
            predict_taken_reg <= 1'b0;
        end
        predict_history_reg <= global_history;
        if (predict_taken_reg) begin
            global_history <= {global_history[5:0], 1'b1};
        end else begin
            global_history <= {global_history[5:0], 1'b0};
        end
    end else if (train_valid) begin
        index <= (train_pc ^ train_history) % 128;
        if (train_mispredicted) begin
            global_history <= train_history;
            if (train_taken) begin
                if (pht[index] != 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                if (pht[index] != 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end else begin
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

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule