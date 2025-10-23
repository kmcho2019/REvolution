module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

reg [1:0] state; // one-hot: state[0]=A, state[1]=B

// Output logic
assign z = (state[0]) ? x : ~x;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= (state[0]) ? (x ? 2'b10 : 2'b01) : 2'b10;
end

endmodule