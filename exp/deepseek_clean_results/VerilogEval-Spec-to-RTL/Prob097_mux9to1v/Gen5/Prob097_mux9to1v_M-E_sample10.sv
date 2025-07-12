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

// Early detection of invalid selection (sel >= 9)
wire invalid_sel = sel[3] & (|sel[2:0]);  // sel >= 9 when MSB=1 and not 8

// First level muxes (4x 2-to-1)
wire [15:0] mux1 [0:3];
assign mux1[0] = sel[0] ? b : a;
assign mux1[1] = sel[0] ? d : c;
assign mux1[2] = sel[0] ? f : e;
assign mux1[3] = sel[0] ? h : g;

// Second level muxes (2x 2-to-1)
wire [15:0] mux2 [0:1];
assign mux2[0] = sel[1] ? mux1[1] : mux1[0];
assign mux2[1] = sel[1] ? mux1[3] : mux1[2];

// Third level mux (1x 2-to-1)
wire [15:0] mux3;
assign mux3 = sel[2] ? i : mux2[1];  // 'i' is the 9th input

// Final selection
always @(*) begin
    if (invalid_sel) begin
        out = {16{1'b1}};  // Default case
    end else begin
        out = sel[2] ? mux3 : mux2[0];  // Choose between top and bottom halves
    end
end

endmodule