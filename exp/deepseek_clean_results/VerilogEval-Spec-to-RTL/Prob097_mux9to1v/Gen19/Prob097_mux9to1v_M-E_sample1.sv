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

// Early detection of invalid selection (sel >= 9)
wire invalid_sel = sel[3]; // MSB set when sel >= 8

// First level muxes (3:1 each)
wire [15:0] mux1_out = (sel[1:0] == 2'b00) ? a :
                       (sel[1:0] == 2'b01) ? b :
                       c;

wire [15:0] mux2_out = (sel[1:0] == 2'b00) ? d :
                       (sel[1:0] == 2'b01) ? e :
                       f;

wire [15:0] mux3_out = (sel[1:0] == 2'b00) ? g :
                       (sel[1:0] == 2'b01) ? h :
                       i;

// Second level mux (4:1)
wire [15:0] valid_out = (sel[2] == 1'b0) ? 
                       ((sel[1] == 1'b0) ? mux1_out : mux2_out) :
                       mux3_out;

// Final output selection
assign out = invalid_sel ? 16'hFFFF : valid_out;

/* Implementation Notes:
   1. Hierarchical muxing reduces fanout and improves timing
   2. Early invalid_sel detection prevents unnecessary mux evaluation
   3. Bitwise processing allows for potential bit-level optimizations
   4. Clean separation of valid/invalid cases improves readability
   5. No redundant default cases in the mux logic
*/

endmodule