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

reg [1:0] gshare_pht [63:0];
reg [6:0] history;
reg [0:0] cond_pht [127:0];

wire [5:0] gshare_index;
wire [6:0] cond_index;

assign gshare_index = {predict_pc[6:2], predict_pc[1] ^ history[1]};
assign cond_index = predict_pc[6:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 7'b0;
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        for (int i = 0; i < 64; i++) begin
            gshare_pht[i] <= 2'b0;
        end
        for (int i = 0; i < 128; i++) begin
            cond_pht[i] <= 1'b0;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                history <= train_history;
            end
            if (train_taken) begin
                if (gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] != 2'b11) begin
                    gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] <= gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] + 1;
                end
                if (cond_pht[train_pc[6:0]] != 1'b1) begin
                    cond_pht[train_pc[6:0]] <= cond_pht[train_pc[6:0]] + 1;
                end
            end else begin
                if (gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] != 2'b00) begin
                    gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] <= gshare_pht[{train_pc[6:2], train_pc[1] ^ train_history[1]}] - 1;
                end
                if (cond_pht[train_pc[6:0]] != 1'b0) begin
                    cond_pht[train_pc[6:0]] <= cond_pht[train_pc[6:0]] - 1;
                end
            end
        end

        if (predict_valid) begin
            predict_taken <= (gshare_pht[gshare_index] >= 2'b10) && (cond_pht[cond_index] == 1'b1);
            predict_history <= history;
            if (!train_valid || !train_mispredicted) begin
                history <= {history[5:0], (gshare_pht[gshare_index] >= 2'b10) && (cond_pht[cond_index] == 1'b1)};
            end
        end
    end
end

endmodule