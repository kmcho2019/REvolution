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

// First level: three 3-to-1 muxes
always @(*) begin
    case (sel[1:0])
        2'd0: mux1_out = a;
        2'd1: mux1_out = b;
        2'd2: mux1_out = c;
        default: mux1_out = 16'hFFFF;
    endcase

    case (sel[1:0])
        2'd0: mux2_out = d;
        2'd1: mux2_out = e;
        2'd2: mux2_out = f;
        default: mux2_out = 16'hFFFF;
    endcase

    case (sel[1:0])
        2'd0: mux3_out = g;
        2'd1: mux3_out = h;
        2'd2: mux3_out = i;
        default: mux3_out = 16'hFFFF;
    endcase
end

// Second level: 3-to-1 mux
always @(*) begin
    if (sel > 4'd8) begin
        out = 16'hFFFF;
    end else begin
        case (sel[3:2])
            2'd0: out = mux1_out;
            2'd1: out = mux2_out;
            2'd2: out = mux3_out;
            default: out = 16'hFFFF;
        endcase
    end
end

endmodule