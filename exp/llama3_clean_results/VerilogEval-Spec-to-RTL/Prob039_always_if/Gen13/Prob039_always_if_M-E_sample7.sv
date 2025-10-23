// Define a module for the lookup table-based multiplexer
module LUTModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_lut,
    output out_always
);

// Define the lookup table
wire [1:0] lut_input = {sel_b1, sel_b2};
reg [1:0] lut_output;

always @(*) begin
    case (lut_input)
        2'b00: lut_output = 2'b01; // Select a
        2'b01: lut_output = 2'b01; // Select a
        2'b10: lut_output = 2'b01; // Select a
        2'b11: lut_output = 2'b10; // Select b
    endcase
end

// Use the lookup table to generate the output
assign out_lut = (lut_output == 2'b10) ? b : a;

// Use the same logic for the procedural assignment
always @(*) begin
    if (sel_b1 && sel_b2) begin
        out_always <= b;
    end else begin
        out_always <= a;
    end
end

endmodule

// The top module encapsulates the lookup table-based module
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Instantiate the lookup table-based module
LUTModule lut_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_lut(out_assign),
    .out_always(out_always)
);

endmodule