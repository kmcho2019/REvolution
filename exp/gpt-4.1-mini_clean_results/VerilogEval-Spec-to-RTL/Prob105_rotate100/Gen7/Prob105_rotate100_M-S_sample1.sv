module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;               // synchronous load
        end else if (ena == 2'b01) begin
            q <= {q[0], q[99:1]};   // rotate right by one bit
        end else if (ena == 2'b10) begin
            q <= {q[98:0], q[99]};  // rotate left by one bit
        end else begin
            q <= q;                 // hold current value
        end
    end

endmodule