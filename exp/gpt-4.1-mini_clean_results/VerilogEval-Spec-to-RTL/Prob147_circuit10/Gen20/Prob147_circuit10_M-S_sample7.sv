module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

// Combinational output based on current state and inputs
assign q = (state & ~(a & b)) | (~state & b);

always @(posedge clk) begin
    state <= q;
end

endmodule