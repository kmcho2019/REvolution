module TopModule (
    input clk,
    input x,
    output z
);

    // Internal asynchronous reset signal, initialized to 1 at time 0
    reg reset_n = 1'b0;  // Active low reset internal signal

    // Release reset_n on first clock edge
    always @(posedge clk) begin
        reset_n <= 1'b1;
    end

    // Flip-flops holding the state of XOR, AND, and OR outputs
    reg ff_xor, ff_and, ff_or;

    // Combinational logic for D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
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