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
    function [1:0] sat_inc;
        input [1:0] cnt;
        begin
            sat_inc = (cnt == 2'b11) ? 2'b11 : cnt + 1;
        end
    endfunction

    // Function for saturating decrement
    function [1:0] sat_dec;
        input [1:0] cnt;
        begin
            sat_dec = (cnt == 2'b00) ? 2'b00 : cnt - 1;
        end
    endfunction

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Initialize PHT
    generate
        genvar i;
        for (i = 0; i < 128; i = i + 1) begin : pht_init
            always @(posedge clk or posedge areset) begin
                if (areset) begin
                    pht[i] <= 2'b01;  // Weakly not-taken
                end
            end
        end
    endgenerate

    // Prediction logic (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training logic (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] next_counter = train_taken ? sat_inc(pht[train_index]) : sat_dec(pht[train_index]);

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
        end else begin
            // PHT update
            if (train_valid) begin
                pht[train_index] <= next_counter;
            end

            // GHR update with priority
            casex ({train_mispredicted, train_valid, predict_valid})
                3'b1??: ghr <= {train_history[5:0], train_taken};  // Misprediction recovery
                3'b01?: ghr <= {ghr[5:0], train_taken};            // Training update
                3'b001: ghr <= {ghr[5:0], predict_taken};          // Prediction update
                default: ghr <= ghr;                                // No update
            endcase
        end
    end

endmodule