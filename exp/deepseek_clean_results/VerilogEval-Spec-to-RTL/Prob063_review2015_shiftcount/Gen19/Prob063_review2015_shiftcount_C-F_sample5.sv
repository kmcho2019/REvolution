module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};  // MSB-first shift
    end
    else if (count_ena) begin
        q <= q - 1'b1;        // Decrement
    end
    // Implicit else holds value (same as explicit q <= q)
end

endmodule