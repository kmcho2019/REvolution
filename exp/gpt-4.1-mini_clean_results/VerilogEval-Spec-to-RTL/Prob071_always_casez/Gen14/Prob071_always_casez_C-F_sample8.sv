module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

integer i;
always @(*) begin
    pos = 3'd0; // Default to 0 if no bits are set
    for (i = 0; i < 8; i = i + 1) begin
        if (in[i]) begin
            pos = i[2:0]; // Assign position and exit loop
            disable for;   // SystemVerilog feature: break out of loop early
        end
    end
end

endmodule