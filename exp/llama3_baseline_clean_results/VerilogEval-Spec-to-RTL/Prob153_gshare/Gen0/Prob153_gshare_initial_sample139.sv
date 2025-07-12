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
reg [6:0] next_global_history;

reg [127:0][1:0] pht;

// Prediction
wire [6:0] predict_index;
assign predict_index = predict_pc ^ global_history;

reg [1:0] predict_counter;
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        global_history <= 7'd0;
        predict_counter <= 2'd0;
    end
    else if (predict_valid)
    begin
        global_history <= next_global_history;
        predict_counter <= pht[predict_index];
    end
end

assign predict_taken = (predict_counter[1] == 1'b1);
assign predict_history = global_history;

always @*
begin
    if (predict_taken)
    begin
        next_global_history = {global_history[5:0], 1'b1};
    end
    else
    begin
        next_global_history = {global_history[5:0], 1'b0};
    end
end

// Training
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        pht <= {128{2'd0}};
    end
    else if (train_valid)
    begin
        if (train_taken)
        begin
            if (pht[train_pc ^ train_history] < 2'd3)
            begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 2'd1;
            end
        end
        else
        begin
            if (pht[train_pc ^ train_history] > 2'd0)
            begin
                pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 2'd1;
            end
        end
        if (train_mispredicted)
        begin
            global_history <= train_history;
        end
    end
end

endmodule