module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a MUX-based approach for the D flip-flop with synchronous reset
always @(posedge clk) begin
    q <= r ? 1'b0 : d; // Direct implementation for comparison
    // Alternative MUX-based implementation
    // q <= (r == 1'b1) ? 1'b0 : d;
    // The above line can also be implemented using a case statement for clarity
    // case (r)
    //     1'b1: q <= 1'b0;
    //     default: q <= d;
    // endcase
end

// Explicit MUX implementation (commented out for demonstration)
// reg mux_out;
// always @(*) begin
//     mux_out = (r == 1'b1) ? 1'b0 : d;
// end
// always @(posedge clk) begin
//     q <= mux_out;
// end

endmodule