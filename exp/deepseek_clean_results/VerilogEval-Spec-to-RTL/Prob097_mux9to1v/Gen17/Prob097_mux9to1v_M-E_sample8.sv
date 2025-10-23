module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

// Level 1: 4-to-1 muxes for input groups
wire [15:0] group0_out = (sel[1:0] == 2'b00) ? a :
                        (sel[1:0] == 2'b01) ? b :
                        (sel[1:0] == 2'b10) ? c : d;

wire [15:0] group1_out = (sel[1:0] == 2'b00) ? e :
                        (sel[1:0] == 2'b01) ? f :
                        (sel[1:0] == 2'b10) ? g : h;

// Level 2: 3-to-1 mux for group selection
wire [15:0] level2_out = (sel[3:2] == 2'b00) ? group0_out :
                        (sel[3:2] == 2'b01) ? group1_out :
                        (sel[3:2] == 2'b10) ? i : 16'hFFFF;

// Final output with default handling
assign out = (sel < 9) ? level2_out : 16'hFFFF;

/* Implementation Notes:
   - Hierarchical mux structure may improve timing in some technologies
   - Early default case handling still present for power optimization
   - Uses conditional operators for compact implementation
   - Could potentially map better to certain FPGA architectures
*/

endmodule