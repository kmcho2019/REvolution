module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

always @(*) begin
    out = {in[ctrl-:0], in[7:ctrl]};  // Rotate right by 'ctrl' positions
end

endmodule