module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

// First stage: Select group based on most significant bits of sel
wire [15:0] group0;
assign group0 = (sel[1:0] == 2'b00) ? a : (sel[1:0] == 2'b01) ? b : c;

wire [15:0] group1;
assign group1 = (sel[1:0] == 2'b00) ? d : (sel[1:0] == 2'b01) ? e : f;

wire [15:0] group2;
assign group2 = (sel[1:0] == 2'b00) ? g : (sel[1:0] == 2'b01) ? h : i;

// Second stage: Select output from chosen group based on least significant bits of sel
wire [15:0] mux_out;
assign mux_out = (sel[3:2] == 2'b00) ? group0 : (sel[3:2] == 2'b01) ? group1 : group2;

// Set output to all '1's if sel is between 9 and 15
assign out = (sel[3] == 1'b1) ? {16{1'b1}} : mux_out;

endmodule