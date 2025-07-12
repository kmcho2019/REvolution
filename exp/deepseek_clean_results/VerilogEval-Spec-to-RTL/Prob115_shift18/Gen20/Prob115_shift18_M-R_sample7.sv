module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Conditional sign extension (only for right shifts)
wire [7:0] sign_ext = {8{q[63]}};

// Next state computation using continuous assignments
wire [63:0] next_q = load ? data : 
                    (ena ? (amount[1] ? 
                           (amount[0] ? {sign_ext, q[63:8]} : // Right by 8
                                     {q[63], q[63:1]})  : // Right by 1
                           (amount[0] ? {q[55:0], 8'b0} :  // Left by 8
                                     {q[62:0], 1'b0})) : // Left by 1
                    q;

// Sequential update
always @(posedge clk) begin
    q <= next_q;
end

endmodule