module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Single counter running on positive clock edge
    reg [CNT_WIDTH-1:0] cnt;
    // Delayed counter value for use in negedge domain
    reg [CNT_WIDTH-1:0] cnt_dly;

    // Synchronous counter with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            cnt_dly <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;
            cnt_dly <= cnt;
        end
    end

    // Combinational generation of clk_div1 and clk_div2 from counters
    wire clk_div1 = (cnt <= HALF_DIV - 1);       // High for counts [0 .. HALF_DIV-1]
    wire clk_div2 = (cnt_dly <= HALF_DIV - 1);  // High similarly on delayed count

    // Final output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule