module TopModule (
    input clk,
    input x,
    output z
);

    // Internal synchronous reset asserted for 1 clock cycle after start
    reg reset;
    reg reset_done;

    always @(posedge clk) begin
        if (!reset_done) begin
            reset <= 1'b1;
            reset_done <= 1'b1;
        end else begin
            reset <= 1'b0;
        end
    end

    // Flip-flops holding the state of XOR, AND, and OR outputs
    reg ff_xor, ff_and, ff_or;

    // Combinational logic for D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
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

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule