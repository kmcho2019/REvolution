module TopModule (
    input         clk,
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

// Initialize q to zero at power-up/reset
initial begin
    q = 4'b0000;
end

always @(posedge clk) begin
    if (shift_ena)
        q <= {q[2:0], data};
    else if (count_ena)
        q <= q - 1;
    // No else branch to avoid unnecessary toggling
end

endmodule