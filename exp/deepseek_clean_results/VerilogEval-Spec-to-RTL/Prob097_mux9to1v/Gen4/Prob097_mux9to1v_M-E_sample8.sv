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
    output reg [15:0] out
);

// First level muxes (group selection)
wire [15:0] group1_out, group2_out, group3_out;

// Group 1: a, b, c
assign group1_out = (sel[1:0] == 2'b00) ? a :
                   (sel[1:0] == 2'b01) ? b :
                   c;

// Group 2: d, e, f
assign group2_out = (sel[1:0] == 2'b00) ? d :
                   (sel[1:0] == 2'b01) ? e :
                   f;

// Group 3: g, h, i
assign group3_out = (sel[1:0] == 2'b00) ? g :
                   (sel[1:0] == 2'b01) ? h :
                   i;

// Second level mux (between groups)
wire [15:0] mux_out;
assign mux_out = (sel[3:2] == 2'b00) ? group1_out :
                (sel[3:2] == 2'b01) ? group2_out :
                group3_out;

// Output with default case handling
always @(*) begin
    out = (sel < 9) ? mux_out : 16'hFFFF;
end

endmodule