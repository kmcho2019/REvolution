module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_Q;

assign next_Q = (j & ~k)           ? 1'b1    :  // Set
                (~j & k)           ? 1'b0    :  // Reset
                (j & k)            ? ~Q      :  // Toggle
                                    Q;          // Hold (j=0, k=0)

always @(posedge clk) begin
    Q <= next_Q;
end

endmodule