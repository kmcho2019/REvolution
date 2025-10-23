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

wire [15:0] mux1_out, mux2_out, mux3_out;
wire [15:0] final_mux_out;
wire invalid_sel;

// First stage: Three 3-to-1 muxes
always @(*) begin
    case (sel[1:0])
        2'b00: mux1_out = a;
        2'b01: mux1_out = b;
        2'b10: mux1_out = c;
        default: mux1_out = 16'hFFFF;
    endcase

    case (sel[1:0])
        2'b00: mux2_out = d;
        2'b01: mux2_out = e;
        2'b10: mux2_out = f;
        default: mux2_out = 16'hFFFF;
    endcase

    case (sel[1:0])
        2'b00: mux3_out = g;
        2'b01: mux3_out = h;
        2'b10: mux3_out = i;
        default: mux3_out = 16'hFFFF;
    endcase
end

// Second stage: Final 3-to-1 mux
always @(*) begin
    case (sel[3:2])
        2'b00: final_mux_out = mux1_out;
        2'b01: final_mux_out = mux2_out;
        2'b10: final_mux_out = mux3_out;
        default: final_mux_out = 16'hFFFF;
    endcase
end

// Handle invalid selection (sel > 8)
assign invalid_sel = (sel > 4'd8);

// Final output selection
always @(*) begin
    out = invalid_sel ? 16'hFFFF : final_mux_out;
end

endmodule