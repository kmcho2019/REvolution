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

wire invalid_sel = (|sel[3:1]) & sel[3]; // Detect sel >= 9
wire [15:0] first_level_out;
wire [15:0] second_level_out;

// First level: 8-to-1 mux using sel[2:0]
assign first_level_out = 
    (sel[2:0] == 3'd0) ? a :
    (sel[2:0] == 3'd1) ? b :
    (sel[2:0] == 3'd2) ? c :
    (sel[2:0] == 3'd3) ? d :
    (sel[2:0] == 3'd4) ? e :
    (sel[2:0] == 3'd5) ? f :
    (sel[2:0] == 3'd6) ? g :
    h;

// Second level: Choose between first level or input i
assign second_level_out = sel[3] ? i : first_level_out;

// Final output with invalid selection handling
assign out = invalid_sel ? 16'hFFFF : second_level_out;

endmodule