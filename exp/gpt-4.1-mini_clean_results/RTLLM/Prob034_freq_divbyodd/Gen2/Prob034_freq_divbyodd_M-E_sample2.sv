module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Odd divisor, default 5
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check that NUM_DIV is odd and greater than 1
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd integer >= 3");
        end
    end

    localparam integer HALF = NUM_DIV >> 1;  // floor(NUM_DIV / 2)
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 1'b0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div; // Toggle at end of full count
            end else if (counter == HALF - 1) begin
                // Toggle output clock halfway through count to generate ~50% duty cycle
                clk_div <= ~clk_div;
                counter <= counter + 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule