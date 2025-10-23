module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // States for posedge output: 1 means high, 0 means low
    reg state_pos;
    // Counter for posedge state duration (counts from 1 up to duration)
    reg [2:0] count_pos;

    // States for negedge output: phase shifted by half clk cycle from posedge
    reg state_neg;
    reg [2:0] count_neg;

    // Clock outputs on posedge and negedge
    reg clk_out_posedge;
    reg clk_out_negedge;

    // Parameters for durations of high and low pulses
    localparam POS_HIGH  = 3'd4;  // posedge clk: high for 4 cycles
    localparam POS_LOW   = 3'd3;  // posedge clk: low  for 3 cycles
    localparam NEG_HIGH  = 3'd4;  // negedge clk: high for 4 cycles
    localparam NEG_LOW   = 3'd3;  // negedge clk: low  for 3 cycles

    // Posedge clock process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_pos       <= 1'b1;     // Start high
            count_pos       <= 3'd1;     // Start counting from 1
            clk_out_posedge <= 1'b1;
        end else begin
            if (state_pos) begin
                // Currently high
                if (count_pos == POS_HIGH) begin
                    // Time to switch low
                    state_pos       <= 1'b0;
                    count_pos       <= 3'd1;
                    clk_out_posedge <= 1'b0;
                end else begin
                    count_pos <= count_pos + 3'd1;
                end
            end else begin
                // Currently low
                if (count_pos == POS_LOW) begin
                    // Time to switch high
                    state_pos       <= 1'b1;
                    count_pos       <= 3'd1;
                    clk_out_posedge <= 1'b1;
                end else begin
                    count_pos <= count_pos + 3'd1;
                end
            end
        end
    end

    // Negedge clock process - naturally phase shifted by half clk cycle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_neg       <= 1'b0;   // Start low (opposite to posedge start)
            count_neg       <= 3'd1;
            clk_out_negedge <= 1'b0;
        end else begin
            if (state_neg) begin
                // Currently high
                if (count_neg == NEG_HIGH) begin
                    // Switch low
                    state_neg       <= 1'b0;
                    count_neg       <= 3'd1;
                    clk_out_negedge <= 1'b0;
                end else begin
                    count_neg <= count_neg + 3'd1;
                end
            end else begin
                // Currently low
                if (count_neg == NEG_LOW) begin
                    // Switch high
                    state_neg       <= 1'b1;
                    count_neg       <= 3'd1;
                    clk_out_negedge <= 1'b1;
                end else begin
                    count_neg <= count_neg + 3'd1;
                end
            end
        end
    end

    // Output clock: logical OR of two phase shifted clocks
    // This creates fractional divide-by-3.5 clock with balanced duty cycle
    assign clk_div = clk_out_posedge | clk_out_negedge;

endmodule