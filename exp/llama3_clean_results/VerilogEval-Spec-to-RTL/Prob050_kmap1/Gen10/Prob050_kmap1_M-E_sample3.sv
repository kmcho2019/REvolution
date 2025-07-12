module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Define the LUT based on the Karnaugh map
// a  bc  | out
// 0  00  | 0
// 0  01  | 1
// 0  11  | 1
// 0  10  | 1
// 1  00  | 1
// 1  01  | 1
// 1  11  | 1
// 1  10  | 1

wire [1:0] bc = {b, c};
reg [1:0] lut_out;

always @(*) begin
    case ({a, bc})
        4'b0000: lut_out = 2'b00;
        4'b0001: lut_out = 2'b01;
        4'b0011: lut_out = 2'b01;
        4'b0010: lut_out = 2'b01;
        4'b1000: lut_out = 2'b01;
        4'b1001: lut_out = 2'b01;
        4'b1011: lut_out = 2'b01;
        4'b1010: lut_out = 2'b01;
        default: lut_out = 2'b00;
    endcase
    out = lut_out[0];
end

endmodule