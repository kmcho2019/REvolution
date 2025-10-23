module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] next_global_history;
reg [1:0] pht [127:0];
reg train_pending;

wire [6:0] index;
assign index = predict_pc ^ global_history;

wire [6:0] train_index;
assign train_index = train_pc ^ train_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        train_pending <= 1'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // Initialize counters to weakly predict not taken
        end
    end else begin
        if (train_valid && train_mispredicted) begin
            next_global_history <= train_history;
        end else if (predict_valid) begin
            next_global_history <= (pht[index] >= 2'b10)? {global_history[5:0], 1'b1} : {global_history[5:0], 1'b0};
        end else begin
            next_global_history <= global_history;
        end
        
        if (train_valid) begin
            train_pending <= 1'b1;
        end else begin
            train_pending <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    global_history <= next_global_history;
end

always @(posedge clk) begin
    if (predict_valid) begin
        predict_taken <= (pht[index] >= 2'b10);
        predict_history <= global_history;
    end
end

always @(posedge clk) begin
    if (train_pending) begin
        if (train_taken) begin
            if (pht[train_index]!= 2'b11) begin
                pht[train_index] <= pht[train_index] + 1'b1;
            end
        end else begin
            if (pht[train_index]!= 2'b00) begin
                pht[train_index] <= pht[train_index] - 1'b1;
            end
        end
    end
end

endmodule