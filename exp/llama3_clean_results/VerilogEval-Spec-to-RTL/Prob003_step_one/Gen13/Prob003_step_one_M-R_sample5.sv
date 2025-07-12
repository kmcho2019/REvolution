module TopModule (
    output one
);
reg one;
always @(*) begin
    one = 1;
end
endmodule