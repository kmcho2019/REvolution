module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q = 4'b0000  // initialize to zero
);

// Alternatively, if the synthesis tool does not support initialization at declaration,
// use an initial block for simulation only:
//
// initial begin
//     q = 4'b0000;
// end

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in data at MSB, shift right
        q <= {data, q[3:1]};
    end else if (count_ena) begin
        // Decrement the 4-bit register with wrap-around
        q <= q - 4'b0001;
    end
    // else q retains its previous value
end

endmodule