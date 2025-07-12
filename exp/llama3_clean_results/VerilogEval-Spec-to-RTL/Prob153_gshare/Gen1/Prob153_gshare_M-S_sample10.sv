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

// GBHR register
reg [6:0] gbhr;
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
    end else if (predict_valid) begin
        gbhr <= {gbhr[5:0], predict_taken};
    end else if (train_valid && train_mispredicted) begin
        gbhr <= train_history;
    end
end

// PHT table
reg [1:0] pht [127:0];
always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else if (train_valid) begin
        reg [1:0] new_val;
        reg [6:0] index;
        index = {predict_pc[6:1], gbhr[0]};
        new_val = pht[index];
        if (train_taken) begin
            if (new_val!= 2'b11) begin
                new_val = new_val + 1'b1;
            end
        end else begin
            if (new_val!= 2'b00) begin
                new_val = new_val - 1'b1;
            end
        end
        pht[index] <= new_val;
    end
end

// prediction logic
always @(posedge clk) begin
    if (predict_valid) begin
        reg [6:0] index;
        index = {predict_pc[6:1], gbhr[0]};
        predict_taken <= pht[index][1];
        predict_history <= gbhr;
    end
end

endmodule