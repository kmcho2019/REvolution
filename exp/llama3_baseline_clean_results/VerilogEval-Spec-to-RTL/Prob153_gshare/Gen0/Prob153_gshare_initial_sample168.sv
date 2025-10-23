module TopModule(
    input           clk,
    input           areset,

    input           predict_valid,
    input  [6:0]     predict_pc,
    output          predict_taken,
    output [6:0]    predict_history,

    input           train_valid,
    input           train_taken,
    input           train_mispredicted,
    input  [6:0]     train_history,
    input  [6:0]     train_pc
);

reg [6:0] global_history;
reg [6:0] next_global_history;

reg [6:0] index;
reg [1:0] counter_value;
reg [6:0] pht [127:0];

always @(*) begin
    // Calculate index by XORing PC and global branch history
    index = predict_pc ^ global_history;
end

always @(*) begin
    // Determine predicted branch direction based on counter value
    if (predict_valid) begin
        predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
        predict_history = global_history;
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset
        global_history <= 7'd0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        // Update global branch history
        if (train_valid && train_mispredicted) begin
            global_history <= train_history;
        end else if (predict_valid) begin
            global_history <= next_global_history;
        end

        // Update pattern history table
        if (train_valid) begin
            if (train_taken) begin
                if (pht[train_pc ^ train_history] != 2'b11) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] + 1;
                end
            end else begin
                if (pht[train_pc ^ train_history] != 2'b00) begin
                    pht[train_pc ^ train_history] <= pht[train_pc ^ train_history] - 1;
                end
            end
        end
    end
end

always @(*) begin
    // Update next global branch history
    if (predict_valid && predict_taken) begin
        next_global_history = {global_history[5:0], 1'b1};
    end else if (predict_valid) begin
        next_global_history = {global_history[5:0], 1'b0};
    end else begin
        next_global_history = global_history;
    end
end

endmodule