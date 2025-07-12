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
reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

assign predict_taken = (pht[{predict_pc, global_history} ^ {7'b0, global_history}] > 1'b1);
assign predict_history = global_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        pht <= {128{2'b00}};
    end else begin
        global_history <= global_history_next;
        pht <= pht_next;
    end
end

always @(*) begin
    global_history_next = global_history;
    pht_next = pht;
    
    if (train_valid) begin
        pht_next[{train_pc, train_history} ^ {7'b0, train_history}] = 
            (train_taken && !train_mispredicted) ? (pht[{train_pc, train_history} ^ {7'b0, train_history}] + 1'b1) :
            (train_taken && train_mispredicted) ? (pht[{train_pc, train_history} ^ {7'b0, train_history}] - 1'b1) :
            (!train_taken && !train_mispredicted) ? (pht[{train_pc, train_history} ^ {7'b0, train_history}] - 1'b1) :
            (!train_taken && train_mispredicted) ? (pht[{train_pc, train_history} ^ {7'b0, train_history}] + 1'b1) : 
            pht[{train_pc, train_history} ^ {7'b0, train_history}];
        
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
    end
    
    if (predict_valid && !train_mispredicted) begin
        global_history_next = {global_history[5:0], predict_taken};
    end
end

endmodule