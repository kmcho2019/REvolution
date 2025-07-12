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
    input  [3:0]  sel,
    output reg [15:0] out
);

    // First level 3-to-1 muxes controlled by sel[1:0]
    reg [15:0] mux0_out;
    reg [15:0] mux1_out;
    reg [15:0] mux2_out;

    always @(*) begin
        case (sel[1:0])
            2'd0: mux0_out = a;
            2'd1: mux0_out = b;
            2'd2: mux0_out = c;
            default: mux0_out = 16'hFFFF; // Should not happen as sel[1:0] max 3
        endcase

        case (sel[1:0])
            2'd0: mux1_out = d;
            2'd1: mux1_out = e;
            2'd2: mux1_out = f;
            default: mux1_out = 16'hFFFF;
        endcase

        case (sel[1:0])
            2'd0: mux2_out = g;
            2'd1: mux2_out = h;
            2'd2: mux2_out = i;
            default: mux2_out = 16'hFFFF;
        endcase
    end

    // Second level 3-to-1 mux controlled by sel[3:2]
    always @(*) begin
        case (sel[3:2])
            2'd0: out = mux0_out;
            2'd1: out = mux1_out;
            2'd2: out = mux2_out;
            default: out = 16'hFFFF;
        endcase
    end

endmodule