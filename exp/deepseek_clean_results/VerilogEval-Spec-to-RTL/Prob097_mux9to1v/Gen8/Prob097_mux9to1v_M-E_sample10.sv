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

wire [15:0] mux4to1_out1, mux4to1_out2;
wire sel_invalid = (sel > 4'd8);  // Detect sel 9-15

// First 4-to-1 mux (handles a-d)
assign mux4to1_out1 = (sel[1:0] == 2'b00) ? a :
                      (sel[1:0] == 2'b01) ? b :
                      (sel[1:0] == 2'b10) ? c : d;

// Second 4-to-1 mux (handles e-h)
assign mux4to1_out2 = (sel[1:0] == 2'b00) ? e :
                      (sel[1:0] == 2'b01) ? f :
                      (sel[1:0] == 2'b10) ? g : h;

// Final 2-to-1 mux (selects between first stage or 'i')
wire [15:0] valid_mux_out = (sel[2]) ? i : 
                           (sel[1] | sel[0]) ? mux4to1_out2 : mux4to1_out1;

// Output with invalid selection handling
assign out = sel_invalid ? 16'hFFFF : valid_mux_out;

endmodule