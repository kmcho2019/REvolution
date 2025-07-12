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

reg [1:0] lbht [127:0]; // Local branch history table
reg [1:0] gbht [127:0]; // Global branch history table
reg [6:0] global_history; // Global branch history

// Local branch history table update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            lbht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        reg [6:0] index = train_pc;
        if (train_taken) begin
            lbht[index] <= (lbht[index] == 2'b11) ? 2'b11 : lbht[index] + 1;
        end else begin
            lbht[index] <= (lbht[index] == 2'b00) ? 2'b00 : lbht[index] - 1;
        end
    end
end

// Global branch history table update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            gbht[i] <= 2'b0;
        end
    end else if (train_valid) begin
        global_history <= {global_history[5:0], train_taken};
        reg [6:0] index = train_pc ^ global_history;
        if (train_taken) begin
            gbht[index] <= (gbht[index] == 2'b11) ? 2'b11 : gbht[index] + 1;
        end else begin
            gbht[index] <= (gbht[index] == 2'b00) ? 2'b00 : gbht[index] - 1;
        end
    end else if (predict_valid) begin
        global_history <= {global_history[5:0], 1'b1};
    end
end

// Prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index = predict_pc ^ global_history;
        predict_taken <= (gbht[index] >= 2'b10) ? 1'b1 : 1'b0;
        predict_history <= global_history;
    end
end

// Training logic
always @(posedge clk) begin
    if (train_valid && train_mispredicted) begin
        global_history <= train_history;
    end
end

endmodule