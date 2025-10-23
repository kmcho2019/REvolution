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
reg [6:0] next_global_history;
reg [6:0] recovered_history;

reg [7:0] predict_index;
reg [7:0] train_index;

reg [1:0] predict_pht_value;
reg [1:0] train_pht_value;
reg [1:0] next_train_pht_value;

reg [127:0] pht [1:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else begin
        global_history <= next_global_history;
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_index = {predict_pc[6], predict_pc[5], predict_pc[4], predict_pc[3], predict_pc[2], predict_pc[1], predict_pc[0]} ^ global_history;
        predict_pht_value = pht[predict_index[0]][predict_index[7:1]];
        next_global_history = global_history;
        if (predict_pht_value[1]) begin
            next_global_history[0] = 1'b1;
        end else begin
            next_global_history[0] = 1'b0;
        end
        predict_taken = predict_pht_value[1];
        predict_history = global_history;
    end else begin
        next_global_history = global_history;
    end
    
    if (train_valid) begin
        train_index = {train_pc[6], train_pc[5], train_pc[4], train_pc[3], train_pc[2], train_pc[1], train_pc[0]} ^ train_history;
        train_pht_value = pht[train_index[0]][train_index[7:1]];
        if (train_mispredicted) begin
            next_global_history = train_history;
        end
        if (train_taken) begin
            next_train_pht_value = (train_pht_value == 2'b11) ? 2'b11 : train_pht_value + 2'b01;
        end else begin
            next_train_pht_value = (train_pht_value == 2'b00) ? 2'b00 : train_pht_value - 2'b01;
        end
    end else begin
        next_train_pht_value = 2'b00;
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        pht[train_index[0]][train_index[7:1]] <= next_train_pht_value;
    end
end

endmodule