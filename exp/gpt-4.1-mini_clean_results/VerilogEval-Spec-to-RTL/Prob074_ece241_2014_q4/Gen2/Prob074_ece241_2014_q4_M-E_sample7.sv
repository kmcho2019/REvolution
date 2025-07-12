module TopModule (
    input  clk,
    input  x,
    output z
);
    // Internal flip-flop registers
    reg q_xor;
    reg q_and;
    reg q_or;

    // Power-on synchronous reset counter (2-bit) and reset signal
    reg [1:0] reset_counter = 2'b00;
    wire reset_active = (reset_counter != 2'b11);

    always @(posedge clk) begin
        if (reset_active)
            reset_counter <= reset_counter + 2'b01;
    end

    // Compute D inputs for flip-flops according to specified logic
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset_active) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule