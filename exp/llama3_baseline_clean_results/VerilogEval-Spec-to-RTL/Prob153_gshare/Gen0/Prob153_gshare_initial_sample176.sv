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
reg [6:0] predict_history_out;
reg predict_taken_out;

reg [127:0] pht [7:0];

always @(*) begin
    pht_index = global_history ^ predict_pc;
    pht_value = pht[pht_index];
    if (pht_value == 2'b00 || pht_value == 2'b01) begin
        predict_taken_out = 1'b0;
    end else begin
        predict_taken_out = 1'b1;
    end
    predict_history_out = global_history;
end

always @(*) begin
    if (predict_valid) begin
        if (predict_taken_out) begin
            global_history_next = {global_history[5:0], 1'b1};
        end else begin
            global_history_next = {global_history[5:0], 1'b0};
        end
    end else begin
        global_history_next = global_history;
    end
end

always @(*) begin
    if (train_valid) begin
        if (train_mispredicted) begin
            global_history_next = train_history;
        end
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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        global_history <= global_history_next;
        if (train_valid) begin
            pht[pht_index] <= pht_value_next;
        end
    end
end

assign predict_taken = predict_taken_out;
assign predict_history = predict_history_out;

endmodule