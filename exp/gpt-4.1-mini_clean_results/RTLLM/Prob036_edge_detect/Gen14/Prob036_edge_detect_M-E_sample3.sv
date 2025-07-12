module edge_detect (
    input  wire clk,    // Clock input
    input  wire rst_n,  // Asynchronous active-low reset
    input  wire a,      // Input signal to detect edges on
    output reg  rise,   // Registered output high for one clock cycle on rising edge of 'a'
    output reg  down    // Registered output high for one clock cycle on falling edge of 'a'
);

    // 2-bit shift register to hold previous two samples of 'a'
    reg [1:0] a_shift;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_shift <= 2'b00;
            rise    <= 1'b0;
            down    <= 1'b0;
        end else begin
            a_shift <= {a_shift[0], a};  // shift left and insert current 'a'

            // Detect rising edge: previous sample=0, current sample=1
            rise <= (~a_shift[0]) & a;

            // Detect falling edge: previous sample=1, current sample=0
            down <= a_shift[0] & (~a);
        end
    end

endmodule