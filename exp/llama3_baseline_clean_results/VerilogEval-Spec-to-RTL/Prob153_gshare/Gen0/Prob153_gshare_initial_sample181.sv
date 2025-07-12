module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] ghr;
reg [6:0] ghr_next;
reg [6:0] pht_index;
reg [1:0] pht_value;
reg [1:0] pht_value_next;
reg predict_taken_reg;

assign predict_taken = predict_taken_reg;
assign predict_history = ghr;

always @(*) begin
    ghr_next = ghr;
    pht_value_next = pht_value;
    predict_taken_reg = 0;

    // Calculate PHT index
    pht_index = predict_pc[6:0] ^ ghr;

    // Handle prediction request
    if (predict_valid) begin
        // Read PHT value
        pht_value = pht[pht_index];

        // Determine predicted branch direction
        if (pht_value[1]) begin
            predict_taken_reg = 1;
        end

        // Update ghr
        if (predict_taken_reg) begin
            ghr_next[6] = 1;
            ghr_next[5:0] = ghr[6:1];
        end else begin
            ghr_next[6] = 0;
            ghr_next[5:0] = ghr[6:1];
        end
    end

    // Handle training request
    if (train_valid) begin
        // Calculate PHT index
        pht_index = train_pc[6:0] ^ train_history;

        // Update PHT value
        if (train_taken) begin
            if (pht_value[1] == 1'b1 && pht_value[0] == 1'b1) begin
                pht_value_next = 2'b11;
            end else begin
                pht_value_next = pht_value + 1;
            end
        end else begin
            if (pht_value[1] == 1'b0 && pht_value[0] == 1'b0) begin
                pht_value_next = 2'b00;
            end else begin
                pht_value_next = pht_value - 1;
            end
        end

        // Recover ghr if misprediction
        if (train_mispredicted) begin
            ghr_next = train_history;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        pht_value <= 2'b00;
    end else begin
        ghr <= ghr_next;
        pht[pht_index] <= pht_value_next;
    end
end

reg [1:0] pht [127:0];

initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b01;
    end
end

endmodule