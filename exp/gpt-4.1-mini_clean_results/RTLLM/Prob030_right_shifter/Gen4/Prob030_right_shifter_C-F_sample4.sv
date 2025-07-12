module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

    // Initialize q to zero
    initial q = 8'b0;

    always @(posedge clk) begin
        // Right shift q by one bit, inserting new input d at MSB
        // q[7] <= d; q[6] <= q[7]; ... q[0] <= q[1];
        q <= {d, q[7:1]};
    end

endmodule