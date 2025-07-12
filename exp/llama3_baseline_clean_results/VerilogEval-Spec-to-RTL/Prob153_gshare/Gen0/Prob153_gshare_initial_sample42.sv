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

reg [6:0] history;
reg [6:0] history_next;

reg [7:0] pht [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
    end else if (train_valid && train_mispredicted) begin
        history <= train_history;
    end else if (predict_valid) begin
        history <= {history[5:0], predict_taken};
    end
end

assign predict_history = history;

assign predict_taken = (pht[{history[6:0] ^ predict_pc[6:0]}][1]);

always @(posedge clk) begin
    if (train_valid) begin
        if (train_taken) begin
            if (pht[{train_history[6:0] ^ train_pc[6:0]}][1] == 0) begin
                pht[{train_history[6:0] ^ train_pc[6:0]}] <= pht[{train_history[6:0] ^ train_pc[6:0]}] + 1;
            end
        end else begin
            if (pht[{train_history[6:0] ^ train_pc[6:0]}][1] == 1) begin
                pht[{train_history[6:0] ^ train_pc[6:0]}] <= pht[{train_history[6:0] ^ train_pc[6:0]}] - 1;
            end
        end
    end
end

initial begin
    for (int i = 0; i < 128; i++) begin
        pht[i] = 2'b01; // Initialize all counters to weakly taken
    end
end

endmodule