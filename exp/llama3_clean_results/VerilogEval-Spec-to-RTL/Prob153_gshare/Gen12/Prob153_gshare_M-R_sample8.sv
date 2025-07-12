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
reg [1:0] cache [127:0];

wire [6:0] predict_index;
wire [6:0] train_index;
wire predict_taken_wire;
wire [6:0] predict_history_wire;
wire [6:0] next_global_history;
wire [1:0] next_cache [127:0];

assign predict_index = predict_pc ^ global_history;
assign train_index = train_pc ^ train_history;
assign predict_taken_wire = (cache[predict_index] == 2'b11 || cache[predict_index] == 2'b10);
assign predict_history_wire = global_history;

always @(*) begin
    next_global_history = global_history;
    for (int i = 0; i < 128; i++) begin
        next_cache[i] = cache[i];
    end

    if (train_valid) begin
        if (train_mispredicted) begin
            next_global_history = train_history;
        end else if (!predict_valid || train_index != predict_index) begin
            if (train_taken) begin
                next_global_history = {global_history[5:0], 1'b1};
            end else begin
                next_global_history = {global_history[5:0], 1'b0};
            end
        end

        if (train_taken) begin
            if (cache[train_index] == 2'b00) begin
                next_cache[train_index] = 2'b01;
            end else if (cache[train_index] == 2'b01) begin
                next_cache[train_index] = 2'b11;
            end
        end else begin
            if (cache[train_index] == 2'b11) begin
                next_cache[train_index] = 2'b10;
            end else if (cache[train_index] == 2'b10) begin
                next_cache[train_index] = 2'b00;
            end
        end
    end else if (predict_valid) begin
        if (train_taken) begin
            next_global_history = {global_history[5:0], 1'b1};
        end else begin
            next_global_history = {global_history[5:0], 1'b0};
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            cache[i] <= 2'b00;
        end
    end else begin
        global_history <= next_global_history;
        predict_taken <= predict_taken_wire;
        predict_history <= predict_history_wire;
        for (int i = 0; i < 128; i++) begin
            cache[i] <= next_cache[i];
        end
    end
end

endmodule