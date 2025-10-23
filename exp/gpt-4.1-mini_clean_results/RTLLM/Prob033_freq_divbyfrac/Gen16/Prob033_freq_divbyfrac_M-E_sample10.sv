module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Parameters
    localparam DIVISOR = 7;          // Divide by 7 cycles total
    localparam TOGGLE_TIMES = 2;     // Toggle output 2 times every 7 clocks for 3.5 division
    localparam ACC_WIDTH = 2;        // 2-bit fractional accumulator: [1:0], representing fraction in 0.0-1.75 range (0.5 steps)

    // We'll represent fraction in fixed-point Q1.1 format:
    // increment = 0.5 = 2'b01
    // accumulator holds value in multiples of 0.5

    reg [2:0] count;                 // counts input clock cycles modulo 7 (0..6)
    reg [ACC_WIDTH-1:0] acc;         // fractional accumulator in Q1.1 format

    wire acc_overflow = acc[1];      // MSB is overflow flag since max acc is 1.5 (3 * 0.5)
    wire [ACC_WIDTH-1:0] acc_incr = 2'b01; // 0.5 increment in Q1.1 format

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 3'd0;
            acc     <= 0;
            clk_div <= 0;
        end else begin
            // Count modulo 7
            if (count == DIVISOR - 1)
                count <= 3'd0;
            else
                count <= count + 3'd1;

            // Add 0.5 to accumulator every clock cycle
            {acc_overflow, acc} <= acc + acc_incr; // Using MSB as overflow carry

            // On overflow toggle clk_div and remove overflow (subtract 1.0)
            if (acc_overflow) begin
                clk_div <= ~clk_div;
                acc <= acc - 2'b10; // subtract 1.0 (2 in Q1.1 format)
            end
        end
    end

endmodule