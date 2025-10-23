// Define a module for the 2-to-1 multiplexer using a LUT
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Define the LUT for the multiplexer
reg [1:0] lut_out;
always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: lut_out = {1'b0, a};
        2'b01: lut_out = {1'b0, a};
        2'b10: lut_out = {1'b0, a};
        2'b11: lut_out = {1'b0, b};
        default: lut_out = {1'b0, a};
    endcase
end

// Assign the output using the LUT value
assign out_assign = lut_out[0];

// Use a procedural if statement to assign the output
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always = b;
    end else begin
        out_always = a;
    end
end

endmodule