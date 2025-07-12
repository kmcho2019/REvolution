module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena == 2'b01)
            q <= {q[0], q[99:1]};   // Rotate right by 1
        else if (ena == 2'b10)
            q <= {q[98:0], q[99]};  // Rotate left by 1
        else
            q <= q;                 // Hold current state
    end

endmodule