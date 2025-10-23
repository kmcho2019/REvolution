module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division 3.5 (7 base counts)
    localparam CNT_MAX = 7; // counts 0..6

    // Counter increments on posedge clk: counts 0 to 6
    reg [2:0] cnt;

    // Generate clk_pos toggles: high at count 0, low at count 4
    reg clk_pos;

    wire clk_pos_set   = (cnt == 3'd0);
    wire clk_pos_clear = (cnt == 3'd4);

    // We'll implement a "half-clock enable" by toggling a flip-flop every clock
    // This acts like a double frequency enable (toggle every clk edge)
    reg clk_div2; // toggles every clock -> serves as half clock enable

    // clk_neg toggles controlled by cnt and clk_div2 enable to produce half-cycle phase shift
    reg clk_neg;

    // clk_neg toggle points chosen to produce 3.5 division with half cycle shift:
    // clk_neg rises at cnt == 3 when clk_div2 == 0
    // clk_neg falls at cnt == 0 when clk_div2 == 0 (start of next cycle)
    // This offsets clk_neg toggling half a clk period after clk_pos toggling

    // Registers to hold toggle requests for clk_neg, synchronously controlled by clk and clk_div2
    reg clk_neg_set_req;
    reg clk_neg_clear_req;

    // Synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_pos <= 1'b0;
            clk_div2 <= 1'b0;
            clk_neg <= 1'b0;
            clk_neg_set_req <= 1'b0;
            clk_neg_clear_req <= 1'b0;
        end else begin
            // Counter increments modulo CNT_MAX
            if (cnt == CNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_pos toggles synchronously on counts
            if (clk_pos_set)
                clk_pos <= 1'b1;
            else if (clk_pos_clear)
                clk_pos <= 1'b0;

            // clk_div2 toggles every clock cycle: serves as 2x frequency enable
            clk_div2 <= ~clk_div2;

            // Generate clk_neg toggle requests only when clk_div2 == 0 (rising edge of half-cycle enable)
            if (clk_div2 == 1'b0) begin
                // Set clk_neg high at cnt==3
                if (cnt == 3'd3)
                    clk_neg_set_req <= 1'b1;
                else
                    clk_neg_set_req <= 1'b0;

                // Set clk_neg low at cnt==0 (next cycle)
                if (cnt == 3'd0)
                    clk_neg_clear_req <= 1'b1;
                else
                    clk_neg_clear_req <= 1'b0;
            end else begin
                // No toggle requests on clk_div2 == 1 (half cycle after posedge)
                clk_neg_set_req <= 1'b0;
                clk_neg_clear_req <= 1'b0;
            end

            // Apply clk_neg toggles on clk_div2 == 0 edge to ensure half-cycle shift
            if (clk_div2 == 1'b0) begin
                if (clk_neg_set_req)
                    clk_neg <= 1'b1;
                else if (clk_neg_clear_req)
                    clk_neg <= 1'b0;
            end
        end
    end

    // Final output: OR of clk_pos and clk_neg to generate fractional divide-by-3.5 clock with ~50% duty cycle
    assign clk_div = clk_pos | clk_neg;

endmodule