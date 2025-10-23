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

    // Parameters for reset values
    parameter GHR_RESET = 7'b0;
    parameter PHT_RESET = 2'b01;  // Weakly not-taken

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Combinational outputs
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    wire pht_update_en = train_valid;
    wire [1:0] new_pht_value = 
        train_taken ? ((pht[train_index] == 2'b11) ? 2'b11 : (pht[train_index] + 1)
                   : ((pht[train_index] == 2'b00) ? 2'b00 : (pht[train_index] - 1);

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT using generate block
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= PHT_RESET;
            end
        end else if (pht_update_en) begin
            pht[train_index] <= new_pht_value;
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= GHR_RESET;
        end else begin
            // Priority: misprediction recovery > prediction update
            ghr <= train_valid && train_mispredicted ? {train_history[5:0], train_taken} :
                   predict_valid ? {ghr[5:0], predict_taken} :
                   ghr;
        end
    end

endmodule