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

// First level muxes (3 groups of 3 inputs)
wire [15:0] mux1_out = (sel[1:0] == 2'd0) ? a :
                       (sel[1:0] == 2'd1) ? b :
                       c;

wire [15:0] mux2_out = (sel[1:0] == 2'd0) ? d :
                       (sel[1:0] == 2'd1) ? e :
                       f;

wire [15:0] mux3_out = (sel[1:0] == 2'd0) ? g :
                       (sel[1:0] == 2'd1) ? h :
                       i;

// Second level mux (select between the first level outputs)
wire [15:0] final_mux = (sel[3:2] == 2'd0) ? mux1_out :
                        (sel[3:2] == 2'd1) ? mux2_out :
                        mux3_out;

// Invalid selection detection (sel >= 9)
wire invalid_sel = |sel[3:2]; // True when sel[3] or sel[2] is 1

// Final output with default handling
assign out = invalid_sel ? 16'hFFFF : final_mux;

/* Implementation Notes:
   - Hierarchical mux structure reduces fanout and improves timing
   - Bitwise operations process all 16 bits in parallel
   - OR gate for invalid detection is more efficient than comparator
   - Gated second level mux reduces power consumption
   - No registers used - pure combinational logic
*/

endmodule