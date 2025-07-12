module TopModule (
    input clk,
    input x,
    output z
);

    reg ff_xor, ff_and, ff_or;
    reg reset;
    reg [1:0] reset_counter;

    // Power-on reset sequence: keep reset asserted for first two clock cycles
    always @(posedge clk) begin
        if (reset_counter != 2'b00)
            reset_counter <= reset_counter - 1;
        else
            reset <= 1'b0;
    end

    initial begin
        reset_counter = 2'b10; // Assert reset for first two clock cycles
        reset = 1'b1;
    end

    // Combinational logic for D inputs of the flip-flops
    wire d_xor = x ^ ff_xor;
    wire d_and = x & (~ff_and);
    wire d_or  = x | (~ff_or);

    // Sequential logic: synchronous reset clears flip-flops to 0
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