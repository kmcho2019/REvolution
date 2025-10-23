module TopModule(
    input            clk,
    input            areset,

    input            predict_valid,
    input      [6:0] predict_pc,
    output reg       predict_taken,
    output reg [6:0] predict_history,

    input            train_valid,
    input            train_taken,
    input            train_mispredicted,
    input      [6:0] train_history,
    input      [6:0] train_pc
);

reg [6:0] gshare_history;
reg [6:0] gshare_history_next;
reg [6:0] pht_index;
reg [6:0] pht_index_next;
reg [1:0] pht_value;
reg [1:0] pht_value_next;

reg [127:0] pht [1:0];

always @(*) begin
    pht_index_next = predict_pc ^ gshare_history;
end

always @(*) begin
    pht_value = pht[pht_index_next][1:0];
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        gshare_history <= 7'b0;
        for (int i = 0; i < 128; i++) begin
            pht[i] <= 2'b01;
        end
    end else begin
        if (train_valid) begin
            if (train_mispredicted) begin
                gshare_history <= train_history;
            end else begin
                gshare_history <= gshare_history;
            end
            if (train_taken) begin
                if (pht[train_pc ^ train_history][1:0] != 2'b11) begin
                    pht[train_pc ^ train_history][1:0] <= pht[train_pc ^ train_history][1:0] + 1'b1;
                end
            end else begin
                if (pht[train_pc ^ train_history][1:0] != 2'b00) begin
                    pht[train_pc ^ train_history][1:0] <= pht[train_pc ^ train_history][1:0] - 1'b1;
                end
            end
        end else if (predict_valid) begin
            gshare_history <= {gshare_history[5:0], predict_taken};
        end else begin
            gshare_history <= gshare_history;
        end
    end
end

always @(*) begin
    predict_taken = (pht_value[1:0] >= 2'b10);
    predict_history = gshare_history;
end

endmodule