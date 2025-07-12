module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

reg [99:0] temp_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena == 2'b01) begin
        // Rotate right by one bit
        temp_q[99:1] <= q[98:0];
        temp_q[0] <= q[99];
        q <= temp_q;
    end else if (ena == 2'b10) begin
        // Rotate left by one bit
        temp_q[98:0] <= q[99:1];
        temp_q[99] <= q[0];
        q <= temp_q;
    end else begin
        // Do not rotate
        q <= q;
    end
end

endmodule