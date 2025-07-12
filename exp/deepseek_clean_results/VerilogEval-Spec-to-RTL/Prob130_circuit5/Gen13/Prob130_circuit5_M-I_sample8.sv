module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Unified control logic
wire [1:0] sel_case = c[1:0];
wire valid = ~(|c[3:2]);  // Active-low invalid signal

// Power-optimized selection with hierarchical control
assign q = valid ? (sel_case == 2'b00 ? b :
                   sel_case == 2'b01 ? e :
                   sel_case == 2'b10 ? a :
                   d) : 4'b0;

endmodule