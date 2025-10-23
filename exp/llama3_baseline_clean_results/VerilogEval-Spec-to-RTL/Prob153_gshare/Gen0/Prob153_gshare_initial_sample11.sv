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

reg [6:0] gh; // global history register
reg [6:0] gh_next; // next value of global history register
reg [127:0] [1:0] pht; // pattern history table
reg [1:0] pht_next [127:0]; // next value of pattern history table

// Compute index into PHT
wire [6:0] index;
assign index = {predict_pc[6], predict_pc[5:0] ^ gh[6:0]};

// Prediction logic
assign predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
assign predict_history = gh;

// Update global history register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gh <= 7'b0;
    end else if (train_valid && train_mispredicted) begin
        gh <= train_history;
    end else if (predict_valid) begin
        gh <= gh_next;
    end
end

// Compute next value of global history register
always @(*) begin
    if (predict_valid) begin
        gh_next = gh;
        if (predict_taken) begin
            gh_next[0] <= 1'b1;
        end else begin
            gh_next[0] <= 1'b0;
        end
        gh_next[6:1] <= gh[5:0];
    end else begin
        gh_next = gh;
    end
end

// Update pattern history table
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b00;
        end
    end else begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= pht_next[i];
        end
    end
end

// Compute next value of pattern history table
always @(*) begin
    for (int i = 0; i < 128; i++) begin
        pht_next[i] = pht[i];
    end
    if (train_valid) begin
        wire [6:0] train_index;
        assign train_index = {train_pc[6], train_pc[5:0] ^ train_history[6:0]};
        if (train_taken) begin
            if (pht[train_index] != 2'b11) begin
                pht_next[train_index] = pht[train_index] + 1'b1;
            end
        end else begin
            if (pht[train_index] != 2'b00) begin
                pht_next[train_index] = pht[train_index] - 1'b1;
            end
        end
    end
end

endmodule