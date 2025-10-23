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

// First level muxes
wire [15:0] mux1_out, mux2_out, mux3_out;

always @(*) begin
    case (sel[1:0])
        2'd0: mux1_out = a;
        2'd1: mux1_out = b;
        2'd2: mux1_out = c;
        default: mux1_out = 16'h0;
    endcase

    case (sel[1:0])
        2'd0: mux2_out = d;
        2'd1: mux2_out = e;
        2'd2: mux2_out = f;
        default: mux2_out = 16'h0;
    endcase

    case (sel[1:0])
        2'd0: mux3_out = g;
        2'd1: mux3_out = h;
        2'd2: mux3_out = i;
        default: mux3_out = 16'h0;
    endcase
end

// Second level mux and output logic
always @(*) begin
    if (sel[3]) begin
        out = 16'hFFFF; // Handle sel 8-15 (since i is sel=8)
    end else begin
        case (sel[2])
            1'b0: out = (sel[1:0] == 2'b11) ? 16'hFFFF : mux1_out;
            1'b1: out = (sel[1:0] == 2'b11) ? 16'hFFFF : mux2_out;
        endcase
    end
end

endmodule