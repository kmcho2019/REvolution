module TopModule #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic sel_b1,
    input  logic sel_b2,
    output logic [WIDTH-1:0] out_assign,
    output logic [WIDTH-1:0] out_always
);

// Create a control signal based on the bitwise AND of sel_b1 and sel_b2
logic control_signal;
assign control_signal = sel_b1 && sel_b2;

// Continuous assignment using the control signal
assign out_assign = control_signal ? b : a;

// Procedural assignment using the control signal
always @(*) begin
    out_always = control_signal ? b : a;
end

endmodule