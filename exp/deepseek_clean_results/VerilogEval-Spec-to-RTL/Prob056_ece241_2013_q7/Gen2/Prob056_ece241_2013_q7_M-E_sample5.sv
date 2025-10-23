module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_state;

assign next_state = (j & k) ? ~Q :     // Toggle when both 1
                   (j & ~k) ? 1'b1 :   // Set when j=1,k=0
                   (~j & k) ? 1'b0 :  // Reset when j=0,k=1
                   Q;                 // Hold when both 0

always @(posedge clk) begin
    Q <= next_state;
end

endmodule