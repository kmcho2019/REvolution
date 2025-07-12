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
reg [127:0][1:0] pht;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        global_history <= 0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else if (train_valid) begin
        if (train_mispredicted) begin
            global_history <= train_history;
        end
        if (train_pc[6:0] ^ global_history[6:0] < 128) begin
            if (train_taken) begin
                if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b00) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b01;
                end else if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b01) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b10;
                end else if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b10) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b11;
                end
            end else begin
                if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b11) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b10;
                end else if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b10) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b01;
                end else if (pht[train_pc[6:0] ^ global_history[6:0]] == 2'b01) begin
                    pht[train_pc[6:0] ^ global_history[6:0]] <= 2'b00;
                end
            end
        end
        if (predict_valid && ~train_mispredicted) begin
            global_history <= {global_history[5:0], predict_taken};
        end
    end else if (predict_valid && ~train_valid) begin
        global_history <= {global_history[5:0], predict_taken};
    end
end

always @(*) begin
    if (predict_valid) begin
        predict_taken = (pht[predict_pc[6:0] ^ global_history[6:0]] > 2'b01);
        predict_history = global_history;
    end else begin
        predict_taken = 0;
        predict_history = 0;
    end
end

endmodule