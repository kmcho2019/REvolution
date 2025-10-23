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

// Early detection of invalid selection
wire invalid_sel = (sel >= 4'd9);

// Stage 1 muxes (4-to-1)
wire [15:0] stage1_0 = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
wire [15:0] stage1_1 = sel[1] ? (sel[0] ? h : g) : (sel[0] ? f : e);
wire [15:0] stage1_2 = i; // Last input handled separately

// Stage 2 muxes (2-to-1)
wire [15:0] stage2_0 = sel[2] ? stage1_1 : stage1_0;

// Final stage mux (2-to-1)
wire [15:0] final_mux = sel[3] ? stage1_2 : stage2_0;

// Output with invalid selection override
assign out = invalid_sel ? 16'hFFFF : final_mux;

/* Implementation Notes:
   - Binary tree structure ensures O(log n) critical path
   - Invalid selection detected in parallel for power efficiency
   - Each bit processed identically in parallel
   - Clean separation of mux stages for better synthesis
   - Total logic depth of 3 for valid selections (1 for invalid)
*/

endmodule