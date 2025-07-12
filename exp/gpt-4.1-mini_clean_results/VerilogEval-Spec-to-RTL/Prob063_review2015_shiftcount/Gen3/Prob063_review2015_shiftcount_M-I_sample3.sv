module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// No reset or initial block: q initializes to unknown (x) by default.
// Shift priority over count, per problem statement (arbitrary).

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in data at MSB, shift right by 1 bit
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement q as 4-bit binary number
        q <= q - 1;
    end
    // else hold q
end

endmodule