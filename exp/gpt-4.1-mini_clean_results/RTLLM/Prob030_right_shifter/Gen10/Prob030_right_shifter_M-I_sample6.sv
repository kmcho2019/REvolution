module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Shift only if d differs from current MSB to reduce unnecessary toggling
    if (d != q[7]) begin
        q <= {d, q[7:1]};
    end
    else begin
        // Hold current state if no change to avoid toggling
        q <= q;
    end
end

endmodule