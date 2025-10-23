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

    // Function for saturating increment
    function [1:0] sat_inc(input [1:0] counter);
        sat_inc = (counter == 2'b11) ? 2'b11 : counter + 1;
    endfunction

    // Function for saturating decrement
    function [1:0] sat_dec(input [1:0] counter);
        sat_dec = (counter == 2'b00) ? 2'b00 : counter - 1;
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction index and logic (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire pht_update_en = train_valid;
    wire [1:0] new_pht_value = train_taken ? sat_inc(pht[train_index]) : sat_dec(pht[train_index]);

    // PHT update (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else if (pht_update_en) begin
            pht[train_index] <= new_pht_value;
        end
    end

    // GHR update (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // Training has priority over prediction
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule