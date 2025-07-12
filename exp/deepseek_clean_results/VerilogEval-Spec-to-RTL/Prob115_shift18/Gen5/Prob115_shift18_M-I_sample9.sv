module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Decode shift amount
wire shift_right = amount[1];
wire shift_8bits = amount[0];

// Compute shifts only when enabled
wire [63:0] shift_result;
assign shift_result = (ena) ? 
    (load ? data : 
        (shift_right ? 
            (shift_8bits ? {{8{q[63]}}, q[63:8]} : {q[63], q[63:1]}) :
            (shift_8bits ? {q[55:0], 8'b0} : {q[62:0], 1'b0})
        )
    ) : q;

always @(posedge clk) begin
    q <= shift_result;
end

endmodule