module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_q;
wire [3:0] shift_mask = {~ena, 3'b111};  // Mask to zero MSB only when shifting

assign next_q = load ? data : 
               (q >> 1) & shift_mask;  // Combined shift and mask operation

always @(posedge clk or posedge areset) begin
    if (areset) q <= 4'b0;
    else        q <= next_q;
end

endmodule