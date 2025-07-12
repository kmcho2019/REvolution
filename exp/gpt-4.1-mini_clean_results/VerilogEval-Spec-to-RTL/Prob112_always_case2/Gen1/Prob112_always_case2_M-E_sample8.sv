module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

integer i;
always @(*) begin
    pos = 2'd0; // default if no bits set
    for (i = 3; i >= 0; i = i - 1) begin
        if (in[i]) begin
            pos = i[1:0]; // assign position and stop checking
            disable for;   // break from for loop (SystemVerilog feature, but here just comment for clarity)
        end
    end
end

endmodule