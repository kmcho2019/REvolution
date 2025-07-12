module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal reset generator - synchronous reset asserted for first 4 clocks after power on
    reg [2:0] reset_counter = 3'd0;
    wire reset = (reset_counter != 3'd4);

    always @(posedge clk) begin
        if (reset_counter != 3'd4)
            reset_counter <= reset_counter + 3'd1;
    end

    // Flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // D inputs computed explicitly
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Synchronous reset and flip-flops update
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

    // Output is NOR of the flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule