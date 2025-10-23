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
reg [6:0] next_history;

reg [1:0] pht [0:127];
reg [1:0] next_pht [0:127];

integer i;

always @(*) begin
    next_history = history;
    for (i = 0; i < 128; i = i + 1) begin
        next_pht[i] = pht[i];
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] <= 2'b01;
        end
        history <= 7'b0;
    end else begin
        history <= next_history;
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] <= next_pht[i];
        end
    end
end

always @(*) begin
    if (train_valid) begin
        if (train_mispredicted) begin
            next_history <= train_history;
        end else if (train_taken) begin
            next_history <= {history[5:0], 1'b1};
        end else begin
            next_history <= {history[5:0], 1'b0};
        end

        case (pht[{predict_pc[6:0] ^ history[6:0]}])
            2'b00: if (train_taken) begin
                         next_pht[{predict_pc[6:0] ^ history[6:0]}] <= 2'b01;
                     end
            2'b01: if (train_taken) begin
                         next_pht[{predict_pc[6:0] ^ history[6:0]}] <= 2'b10;
                     end else begin
                         next_pht[{predict_pc[6:0] ^ history[6:0]}] <= 2'b00;
                     end
            2'b10: if (~train_taken) begin
                         next_pht[{predict_pc[6:0] ^ history[6:0]}] <= 2'b01;
                     end
            2'b11: if (~train_taken) begin
                         next_pht[{predict_pc[6:0] ^ history[6:0]}] <= 2'b10;
                     end
        endcase
    end else if (predict_valid) begin
        if (pht[{predict_pc[6:0] ^ history[6:0]}] >= 2'b10) begin
            predict_taken = 1'b1;
        end else begin
            predict_taken = 1'b0;
        end

        predict_history = history;

        if (predict_taken) begin
            next_history <= {history[5:0], 1'b1};
        end else begin
            next_history <= {history[5:0], 1'b0};
        end
    end
end

endmodule