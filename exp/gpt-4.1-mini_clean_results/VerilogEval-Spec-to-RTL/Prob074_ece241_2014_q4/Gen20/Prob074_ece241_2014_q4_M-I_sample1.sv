module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal asynchronous reset generator: asserted at power-on,
    // stays high for 4 clock cycles, then deasserted.
    reg [3:0] reset_shift = 4'b1111; // start asserted (all ones)

    always @(posedge clk) begin
        if (reset_shift != 4'b0000)
            reset_shift <= {reset_shift[2:0], 1'b0};
    end

    wire reset = reset_shift[3]; // MSB is the reset signal, asynchronously active high

    // Flip-flop outputs with asynchronous active-high reset
    reg ff_xor, ff_and, ff_or;

    // D inputs computed explicitly
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Asynchronous reset flip-flops: reset active high, synchronous data load on clk posedge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ff_xor <= 1'b0;
            ff_and <= 1'b0;
            ff_or  <= 1'b0;
        end else begin
            ff_xor <= d_xor;
            ff_and <= d_and;
            ff_or  <= d_or;
        end
    end

    // Output is NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule