// Define a parameterized module for the control logic
module ControlLogic #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] sel_b1,
    input  [WIDTH-1:0] sel_b2,
    output [WIDTH-1:0] select
);

// Use bitwise AND operation to generate the select signal
assign select = sel_b1 & sel_b2;

endmodule

// Define a parameterized module for the data processing
module DataProcessing #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] select,
    output [WIDTH-1:0] out_assign,
    output [WIDTH-1:0] out_always
);

// Use bitwise AND and OR operations to select the output
assign out_assign = (select == 1'b1)? b : a;
assign out_always = (select == 1'b1)? b : a;

endmodule

// The top module encapsulates the control logic and data processing modules
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Instantiate the control logic module
ControlLogic control_logic_module(
   .sel_b1(sel_b1),
   .sel_b2(sel_b2),
   .select(select)
);

// Instantiate the data processing module
DataProcessing data_processing_module(
   .a(a),
   .b(b),
   .select(select),
   .out_assign(out_assign),
   .out_always(out_always)
);

// Internal wire for the select signal
wire select;

endmodule