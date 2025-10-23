module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;
end

always @(posedge clk) begin
    // Shift only if input bit d differs from current MSB to reduce toggling
    if (d != q[7]) begin
        q <= {d, q[7:1]};
    end
    else begin
        q <= q; // Hold current value to avoid toggling
    end
end

endmodule