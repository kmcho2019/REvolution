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
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [1:0] pht_value_next;
reg predict_taken_reg;

wire [6:0] pht_index_wire = {global_history[6:1] ^ predict_pc};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
    end else if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end else if (predict_valid) begin
        global_history <= global_history_next;
    end
end

always @(*) begin
    pht_index = pht_index_wire;
    pht_value = pht[pht_index];
    predict_taken_reg = (pht_value == 2'b10 || pht_value == 2'b11);
    predict_history = global_history;

    global_history_next = {global_history[5:0], predict_taken_reg};

    if (train_valid) begin
        if (train_taken) begin
            if (pht_value == 2'b11) begin
                pht_value_next = 2'b11;
            end else begin
                pht_value_next = pht_value + 1'b1;
            end
        end else begin
            if (pht_value == 2'b00) begin
                pht_value_next = 2'b00;
            end else begin
                pht_value_next = pht_value - 1'b1;
            end
        end
    end else begin
        pht_value_next = pht_value;
    end
end

reg [1:0] pht [127:0];

always @(posedge clk) begin
    if (train_valid) begin
        pht[pht_index_wire] <= pht_value_next;
    end
end

assign predict_taken = predict_taken_reg;

endmodule