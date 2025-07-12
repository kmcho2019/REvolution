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

    reg [6:0] ghr;
    reg [6:0] ghr_next;
    reg [1:0] pht [127:0];
    reg [1:0] pht_next [127:0];

    // prediction logic
    wire [6:0] index;
    assign index = predict_pc ^ ghr;
    assign predict_taken = (pht[index] == 2'b11 || pht[index] == 2'b10);
    assign predict_history = ghr;

    // training logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b0;
            end
        end else begin
            ghr <= ghr_next;
            for (int i = 0; i < 128; i++) begin
                pht[i] <= pht_next[i];
            end
        end
    end

    // update ghr and pht
    always @(*) begin
        ghr_next = ghr;
        for (int i = 0; i < 128; i++) begin
            pht_next[i] = pht[i];
        end
        if (train_valid) begin
            wire [6:0] train_index;
            assign train_index = train_pc ^ train_history;
            if (train_mispredicted) begin
                ghr_next = train_history;
            end
            if (train_taken) begin
                if (pht[train_index] != 2'b11) begin
                    pht_next[train_index] = pht[train_index] + 1;
                end
            end else begin
                if (pht[train_index] != 2'b00) begin
                    pht_next[train_index] = pht[train_index] - 1;
                end
            end
        end else if (predict_valid) begin
            ghr_next[6] = predict_taken;
            ghr_next[5:0] = ghr[6:1];
        end
    end

endmodule