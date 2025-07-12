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

reg [1:0] pht [127:0];
reg [6:0] gbhr;
reg [6:0] next_gbhr;
reg [3:0] gbhr_lower;
reg [2:0] gbhr_upper;
reg [3:0] next_gbhr_lower;
reg [2:0] next_gbhr_upper;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        gbhr <= 7'b0;
        gbhr_lower <= 4'b0;
        gbhr_upper <= 3'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01; // initialize to weakly taken
        end
    end else begin
        if (predict_valid) begin
            reg [6:0] index;
            index = {predict_pc[6:1] ^ gbhr[5:0]};
            if (pht[index] == 2'b00 || pht[index] == 2'b01) begin
                predict_taken <= 1'b0;
            end else begin
                predict_taken <= 1'b1;
            end
            predict_history <= gbhr;
        end

        if (train_valid) begin
            reg [6:0] index;
            index = {train_pc[6:1] ^ train_history[5:0]};
            if (train_mispredicted) begin
                gbhr <= train_history;
            end else begin
                if (train_taken) begin
                    next_gbhr_lower <= {gbhr_lower[2:0], 1'b1};
                end else begin
                    next_gbhr_lower <= {gbhr_lower[2:0], 1'b0};
                end
                if (train_taken) begin
                    next_gbhr_upper <= gbhr_upper + 1'b1;
                end else begin
                    next_gbhr_upper <= gbhr_upper - 1'b1;
                end
            end
            if (train_taken) begin
                if (pht[index]!= 2'b11) begin
                    pht[index] <= pht[index] + 1'b1;
                end
            end else begin
                if (pht[index]!= 2'b00) begin
                    pht[index] <= pht[index] - 1'b1;
                end
            end
        end else if (predict_valid) begin
            if (predict_taken) begin
                next_gbhr_lower <= {gbhr_lower[2:0], 1'b1};
            end else begin
                next_gbhr_lower <= {gbhr_lower[2:0], 1'b0};
            end
        end
        gbhr_lower <= next_gbhr_lower;
        gbhr_upper <= next_gbhr_upper;
        gbhr <= {gbhr_upper, gbhr_lower};
    end
end

endmodule