module TopModule(
    input  a,
    input  b,
    output out
);

always @(*)
begin
    case({a, b})
        2'b00: out = 1'b1;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b0;
        default: out = 1'b0; // This should never be reached, but added for completeness
    endcase
end

endmodule