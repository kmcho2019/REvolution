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

wire [8:0] sel_decoded;
wire [15:0] mux_out;
wire default_case;

// One-hot decoder for sel[3:0]
assign sel_decoded[0] = (sel == 4'd0);
assign sel_decoded[1] = (sel == 4'd1);
assign sel_decoded[2] = (sel == 4'd2);
assign sel_decoded[3] = (sel == 4'd3);
assign sel_decoded[4] = (sel == 4'd4);
assign sel_decoded[5] = (sel == 4'd5);
assign sel_decoded[6] = (sel == 4'd6);
assign sel_decoded[7] = (sel == 4'd7);
assign sel_decoded[8] = (sel == 4'd8);

// Detect default case
assign default_case = (sel > 4'd8);

// Create mux using decoded signals
assign mux_out = (sel_decoded[0] ? a : 16'b0) |
                 (sel_decoded[1] ? b : 16'b0) |
                 (sel_decoded[2] ? c : 16'b0) |
                 (sel_decoded[3] ? d : 16'b0) |
                 (sel_decoded[4] ? e : 16'b0) |
                 (sel_decoded[5] ? f : 16'b0) |
                 (sel_decoded[6] ? g : 16'b0) |
                 (sel_decoded[7] ? h : 16'b0) |
                 (sel_decoded[8] ? i : 16'b0);

// Handle default case
assign out = default_case ? 16'hFFFF : mux_out;

endmodule