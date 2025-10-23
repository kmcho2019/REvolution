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

// 128-entry table of two-bit saturating counters
reg [1:0] pht [127:0];

// 7-bit global branch history register
reg [6:0] gbr;

// Initialize the global branch history register and the pattern history table
initial begin
    gbr = 7'b0;
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b01;
    end
end

// Update the global branch history register and the pattern history table on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        // Update the global branch history register
        if (predict_valid) begin
            gbr <= {gbr[5:0], predict_taken};
        end

        // Update the pattern history table
        if (train_valid) begin
            reg [6:0] index;
            index = train_pc ^ train_history;
            if (train_mispredicted) begin
                // Recover the global branch history register
                gbr <= train_history;
            end
            if (train_taken) begin
                // Increment the counter if the branch was taken
                if (pht[index]!= 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                // Decrement the counter if the branch was not taken
                if (pht[index]!= 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end
    end
end

// Make a prediction when predict_valid is high
always @(*) begin
    reg [6:0] index;
    index = predict_pc ^ gbr;
    predict_taken = (pht[index] >= 2'b10);
    predict_history = gbr;
end

endmodule