module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;

    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges on each bit: delayed_in=1 and current in=0
            // Latch falling edge detection in out until reset
            out <= out | (delayed_in & ~in);
            delayed_in <= in;
        end
    end

endmodule