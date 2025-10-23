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

// Unified PHT and GBHR structure
reg [1:0] pht_gbhr [127:0];
reg [6:0] gbhr;
reg [6:0] next_gbhr;

// prediction logic
assign predict_taken = (pht_gbhr[{predict_pc[6:1] ^ gbhr[5:0]}] == 2'b10 || pht_gbhr[{predict_pc[6:1] ^ gbhr[5:0]}] == 2'b11)? 1'b1 : 1'b0;
assign predict_history = {gbhr[5:0], predict_taken};

// next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        gbhr <= 7'b0;
        next_gbhr <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht_gbhr[i] <= 2'b01; // initialize to weakly taken
        end
    end else begin
        reg [6:0] predict_index;
        reg [6:0] train_index;
        predict_index = {predict_pc[6:1] ^ gbhr[5:0]};
        train_index = {train_pc[6:1] ^ train_history[5:0]};

        if (train_valid) begin
            next_gbhr <= train_mispredicted? train_history : (train_taken? {gbhr[5:0], 1'b1} : {gbhr[5:0], 1'b0});
            if (train_taken) begin
                if (pht_gbhr[train_index]!= 2'b11) begin
                    pht_gbhr[train_index] <= pht_gbhr[train_index] + 1'b1;
                end
            end else begin
                if (pht_gbhr[train_index]!= 2'b00) begin
                    pht_gbhr[train_index] <= pht_gbhr[train_index] - 1'b1;
                end
            end
        end else if (predict_valid &&!train_valid) begin
            next_gbhr <= predict_taken? {gbhr[5:0], 1'b1} : {gbhr[5:0], 1'b0};
        end

        gbhr <= next_gbhr;
    end
end

endmodule