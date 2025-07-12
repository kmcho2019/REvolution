module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire [99:0] next_q;

    // Combinational next state calculation using assign and conditional operator
    assign next_q = load ? data :
                    (ena == 2'b01) ? {q[0], q[99:1]} :    // rotate right
                    (ena == 2'b10) ? {q[98:0], q[99]} :   // rotate left
                    q;                                     // hold

    // Sequential register update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule