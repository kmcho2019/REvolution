module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] next_q = load ? data : 
                    (ena ? (amount[1] ? 
                            (amount[0] ? q >>> 8 : q >>> 1) : 
                            (amount[0] ? q << 8 : q << 1)) : 
                    q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule