module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_q;

// Circular rotation logic
assign next_q = shift_ena ? {q[2:0], data} :  // Left rotate for shift
                count_ena ? {q[0], q[3:1]} :  // Right rotate for count
                q;                             // Hold value

always @(posedge clk) begin
    q <= next_q;
end

endmodule