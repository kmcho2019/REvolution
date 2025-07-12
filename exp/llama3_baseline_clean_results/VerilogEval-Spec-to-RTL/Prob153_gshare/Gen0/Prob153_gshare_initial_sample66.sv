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
reg [6:0] next_global_history;
reg [1:0] pht [127:0];
reg [6:0] pht_index;

assign predict_history = global_history;

always @(*) begin
    pht_index = predict_pc ^ global_history;
    if (pht[pht_index] == 2'b11 || pht[pht_index] == 2'b10) begin
        predict_taken = 1'b1;
    end else begin
        predict_taken = 1'b0;
    end
end

always @(posedge clk) begin
    if (~areset) begin
        global_history <= 7'b0;
        next_global_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b0;
        end
    end else begin
        global_history <= next_global_history;
        if (predict_valid) begin
            next_global_history <= {global_history[5:0], predict_taken};
        end else if (train_valid && train_mispredicted) begin
            next_global_history <= train_history;
        end
        if (train_valid) begin
            pht_index = train_pc ^ train_history;
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht[pht_index] <= pht[pht_index] + 1'b1;
                end
            end else begin
                if (pht[pht_index] != 2'b00) begin
                    pht[pht_index] <= pht[pht_index] - 1'b1;
                end
            end
        end
    end
end

endmodule