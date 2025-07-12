module TopModule(
    input  [3:0] x,
    output reg   f
);

// Create an address that corresponds to the Karnaugh map row and column bits
// addr = {x[2], x[3], x[0], x[1]} as per map definition
wire [3:0] addr;
assign addr = {x[2], x[3], x[0], x[1]};

always @(*) begin
    case(addr)
        4'd0:  f = 1; // 00 00
        4'd2:  f = 1; // 00 10
        4'd8:  f = 1; // 10 00
        4'd9:  f = 1; // 10 01
        4'd10: f = 1; // 10 10
        4'd12: f = 1; // 11 00
        4'd13: f = 1; // 11 01
        4'd15: f = 1; // 11 11
        default: f = 0;
    endcase
end

endmodule