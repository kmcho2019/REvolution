module TopModule (
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
reg [6:0] pht_index;
reg [1:0] pht_entry;
reg predict_taken_reg;

always @(*) begin
    pht_index = {predict_pc[6:2], global_history[5:0]};
end

reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b01}};
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                global_history <= train_history;
            end
            if (train_taken) begin
                if (pht[{train_pc[6:2], train_history[5:0]}] != 2'b11) begin
                    pht[{train_pc[6:2], train_history[5:0]}] <= pht[{train_pc[6:2], train_history[5:0]}] + 1'b1;
                end
            end else begin
                if (pht[{train_pc[6:2], train_history[5:0]}] != 2'b00) begin
                    pht[{train_pc[6:2], train_history[5:0]}] <= pht[{train_pc[6:2], train_history[5:0]}] - 1'b1;
                end
            end
        end
        if (predict_valid) begin
            if (pht[pht_index] >= 2'b10) begin
                predict_taken_reg <= 1'b1;
            end else begin
                predict_taken_reg <= 1'b0;
            end
            if (predict_taken_reg) begin
                global_history <= {global_history[5:0], 1'b1};
            end else begin
                global_history <= {global_history[5:0], 1'b0};
            end
        end
    end
end

always @(*) begin
    predict_taken = predict_taken_reg;
    predict_history = global_history;
end

endmodule