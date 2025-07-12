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

reg [6:0] gbhr;
reg [6:0] gbhr_next;

reg [1:0] pht [127:0];
reg [1:0] pht_next [127:0];

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'd0;
        for (i = 0; i < 128; i++) begin
            pht[i] <= 2'd0;
        end
    end else begin
        gbhr <= gbhr_next;
        for (i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

always @(*) begin
    gbhr_next = gbhr;
    for (i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end

    // Calculate index into PHT
    reg [6:0] predict_index;
    reg [6:0] train_index;
    assign predict_index = predict_pc ^ gbhr;
    assign train_index = train_pc ^ train_history;

    // Prediction
    if (predict_valid) begin
        // Update GBHR based on prediction
        if (pht[predict_index] >= 2'd2) begin // Taken
            gbhr_next[0] = 1'b1;
        end else begin // Not Taken
            gbhr_next[0] = 1'b0;
        end
        // Shift in the new bit
        gbhr_next[6:1] = gbhr[5:0];
    end

    // Training
    if (train_valid) begin
        if (train_mispredicted) begin
            // Recovery: restore GBHR to its state after the mispredicted branch
            gbhr_next = train_history;
        end

        // Update PHT
        if (train_taken) begin
            if (pht[train_index] != 2'd3) begin
                pht_next[train_index] = pht[train_index] + 1;
            end
        end else begin
            if (pht[train_index] != 2'd0) begin
                pht_next[train_index] = pht[train_index] - 1;
            end
        end
    end
end

always @(*) begin
    if (pht[predict_pc ^ gbhr] >= 2'd2) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
    predict_history = gbhr;
end

endmodule