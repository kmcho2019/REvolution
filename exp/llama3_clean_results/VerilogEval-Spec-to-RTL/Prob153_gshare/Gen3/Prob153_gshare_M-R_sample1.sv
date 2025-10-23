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

// GBHR register
reg [6:0] gbhr;
reg [6:0] next_gbhr;

// PHT table
reg [1:0] pht [127:0];
reg [1:0] next_pht [127:0];

// prediction logic
assign predict_taken = (pht[{predict_pc[6:1] ^ gbhr[5:0]}] == 2'b11 || pht[{predict_pc[6:1] ^ gbhr[5:0]}] == 2'b10);
assign predict_history = gbhr;

// next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else begin
        gbhr <= next_gbhr;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= next_pht[i];
        end
    end
end

// next state computation
always @(*) begin
    next_gbhr = gbhr;
    for (int i = 0; i < 128; i++) begin
        next_pht[i] = pht[i];
    end

    if (train_valid) begin
        reg [6:0] index;
        index = {train_pc[6:1] ^ train_history[5:0]};
        next_gbhr = train_mispredicted ? train_history : next_gbhr;
        if (train_taken) begin
            if (pht[index] != 2'b11) begin
                next_pht[index] = pht[index] + 1'b1;
            end
        end else begin
            if (pht[index] != 2'b00) begin
                next_pht[index] = pht[index] - 1'b1;
            end
        end
    end

    if (predict_valid && !train_valid) begin
        next_gbhr = {gbhr[5:0], predict_taken};
    end
end

endmodule