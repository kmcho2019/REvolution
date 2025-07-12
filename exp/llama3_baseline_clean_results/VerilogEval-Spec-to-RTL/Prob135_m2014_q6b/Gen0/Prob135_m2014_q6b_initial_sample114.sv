module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

reg Y1_next;
assign Y1_next = (y == 3'b001 && w == 1) || 
                 (y == 3'b011 && w == 0) || 
                 (y == 3'b011 && w == 1) || 
                 (y == 3'b100 && w == 1) || 
                 (y == 3'b101 && w == 0) || 
                 (y == 3'b101 && w == 1);

always @(posedge w or posedge y)
begin
    Y1 <= Y1_next;
end

assign Y1 = Y1_next;

endmodule