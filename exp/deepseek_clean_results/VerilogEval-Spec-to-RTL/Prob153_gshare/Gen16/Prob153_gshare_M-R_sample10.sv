module TopModule (
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

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction index and output
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    wire pht_update_en = train_valid;
    wire [1:0] pht_update_value = train_taken ? 
                                 (pht[train_index] == 2'b11 ? 2'b11 : pht[train_index] + 1) :
                                 (pht[train_index] == 2'b00 ? 2'b00 : pht[train_index] - 1);

    // GHR next value logic
    wire ghr_update_en = predict_valid && (!train_valid || !train_mispredicted);
    wire [6:0] ghr_next = train_mispredicted ? {train_history[5:0], train_taken} :
                         ghr_update_en ? {ghr[5:0], predict_taken} :
                         ghr;

    // PHT update sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else if (pht_update_en) begin
            pht[train_index] <= pht_update_value;
        end
    end

    // GHR update sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            ghr <= ghr_next;
        end
    end

endmodule