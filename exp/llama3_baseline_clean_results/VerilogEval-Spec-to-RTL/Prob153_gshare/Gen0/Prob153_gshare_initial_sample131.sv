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
reg [127:0][1:0] pht;
reg [127:0][1:0] pht_next;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        pht <= {128{2'b0}};
    end else begin
        history <= history_next;
        pht <= pht_next;
    end
end

always_comb begin
    history_next = history;
    pht_next = pht;

    if (train_valid) begin
        // Calculate index
        reg [6:0] index;
        index = {train_pc[6:1], train_history[0]};
        // Update PHT
        if (train_mispredicted) begin
            if (train_taken)
                pht_next[index] = (pht[index] == 2'b11) ? 2'b11 : pht[index] + 1;
            else
                pht_next[index] = (pht[index] == 2'b00) ? 2'b00 : pht[index] - 1;
        end
        // Recover branch history register
        if (train_mispredicted) begin
            history_next = train_history;
        end
    end

    if (predict_valid) begin
        // Calculate index
        reg [6:0] index;
        index = {predict_pc[6:1], history[0]};
        // Update branch history register
        if (train_valid && train_mispredicted) begin
            // do nothing
        end else begin
            history_next = {history[5:0], (pht[index] >= 2'b10) ? 1'b1 : 1'b0};
        end
    end
end

always_comb begin
    predict_taken = (pht[{predict_pc[6:1], history[0]}] >= 2'b10) ? 1'b1 : 1'b0;
    predict_history = history;
end

endmodule