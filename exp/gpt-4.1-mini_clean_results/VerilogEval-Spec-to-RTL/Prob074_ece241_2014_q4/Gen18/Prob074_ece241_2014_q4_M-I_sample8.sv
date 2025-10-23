module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal reset generation: power-on reset pulse for a few cycles
    reg [1:0] reset_counter = 2'b11; // start with reset asserted (active high)

    always @(posedge clk) begin
        if (reset_counter != 2'b00)
            reset_counter <= reset_counter - 2'b01;
    end
    wire reset = (reset_counter != 2'b00); // reset active while counter > 0

    // State registers with asynchronous active-high reset
    reg q_xor, q_and, q_or;

    // Combinational inputs for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with asynchronous reset (assumed active high reset)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output: NOR of flip-flops outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule