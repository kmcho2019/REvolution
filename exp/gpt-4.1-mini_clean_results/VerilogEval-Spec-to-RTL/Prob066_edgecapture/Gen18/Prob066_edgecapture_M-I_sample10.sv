module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;

    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= in;   // Initialize delayed_in to input at reset for correct first cycle edge detection
            out <= 32'b0;
        end else begin
            delayed_in <= in;
            // Detect falling edges: bits that were 1 before and now 0
            // Update out only when new falling edge detected to reduce toggling
            out <= ( (delayed_in & ~in) != 0 ) ? (out | (delayed_in & ~in)) : out;
        end
    end

endmodule