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
reg [6:0] global_history_next;
reg [127:0] pht [1:0];
reg [6:0] pht_index;
reg predict_taken_next;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'd0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], predict_taken_next};
    end
end

always @(*) begin
    pht_index = predict_pc[6:0] ^ global_history;
    if (pht[pht_index][1]) begin
        predict_taken_next = 1'b1;
    end else begin
        predict_taken_next = 1'b0;
    end
end

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[train_pc[6:0] ^ train_history][1]) begin
                if (train_mispredicted) begin
                    pht[train_pc[6:0] ^ train_history][1] <= 1'b1;
                end else if (pht[train_pc[6:0] ^ train_history][0]) begin
                    pht[train_pc[6:0] ^ train_history][1:0] <= 2'b10;
                end
            end else begin
                pht[train_pc[6:0] ^ train_history][1:0] <= 2'b01;
            end
        end else begin
            if (~pht[train_pc[6:0] ^ train_history][1]) begin
                if (train_mispredicted) begin
                    pht[train_pc[6:0] ^ train_history][1] <= 1'b0;
                end else if (~pht[train_pc[6:0] ^ train_history][0]) begin
                    pht[train_pc[6:0] ^ train_history][1:0] <= 2'b00;
                end
            end else begin
                pht[train_pc[6:0] ^ train_history][1:0] <= 2'b10;
            end
        end
    end
end

assign predict_taken = predict_taken_next;
assign predict_history = global_history;

endmodule