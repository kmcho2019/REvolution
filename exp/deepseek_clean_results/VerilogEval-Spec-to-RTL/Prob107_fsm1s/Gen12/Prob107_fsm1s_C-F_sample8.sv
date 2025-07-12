module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State register (0=B, 1=A)
    reg state;

    // State transition using optimized XOR logic
    always @(posedge clk) begin
        state <= reset ? 1'b0 : (state ^ ~in);
    end

    // Output is simply the inverted state
    assign out = ~state;

endmodule