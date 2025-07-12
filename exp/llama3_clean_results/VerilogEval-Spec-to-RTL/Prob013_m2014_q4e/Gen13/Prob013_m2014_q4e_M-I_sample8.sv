module TopModule(
    input  in1,
    input  in2,
    output out
);
always @(*) begin
    case ({in1, in2})
        2'b00: out = 1'b1;
        default: out = 1'b0;
    endcase
end
endmodule