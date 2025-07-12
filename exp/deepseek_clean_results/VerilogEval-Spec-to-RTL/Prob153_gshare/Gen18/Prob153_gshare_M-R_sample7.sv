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

    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;
    wire pht_update = train_valid;
    wire [1:0] new_pht_value = 
        (pht[train_index] == 2'b11 && train_taken) ? 2'b11 :
        (pht[train_index] == 2'b00 && !train_taken) ? 2'b00 :
        train_taken ? pht[train_index] + 1 : pht[train_index] - 1;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else if (pht_update) begin
            pht[train_index] <= new_pht_value;
        end
    end

    // GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid && (!train_valid || !train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule