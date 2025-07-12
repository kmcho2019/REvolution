module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

    initial q = 8'b0;

    // Sequential logic to handle clock edge
    always @(posedge clk) begin
        q <= {d, q[7:1]};
    end

    // No additional combinational logic needed in this case
    // The assignment within the always block already handles the shifting and insertion

endmodule