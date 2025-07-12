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

    wire [15:0] mux0_out; // mux selecting among a,b,c
    wire [15:0] mux1_out; // mux selecting among d,e,f
    wire [15:0] mux2_out; // mux selecting among g,h,i

    // First level: 3-to-1 muxes
    always @(*) begin
        case(sel[1:0])
            2'b00: mux0_out = a;
            2'b01: mux0_out = b;
            2'b10: mux0_out = c;
            default: mux0_out = 16'hFFFF;
        endcase
    end

    always @(*) begin
        case(sel[1:0])
            2'b00: mux1_out = d;
            2'b01: mux1_out = e;
            2'b10: mux1_out = f;
            default: mux1_out = 16'hFFFF;
        endcase
    end

    always @(*) begin
        case(sel[1:0])
            2'b00: mux2_out = g;
            2'b01: mux2_out = h;
            2'b10: mux2_out = i;
            default: mux2_out = 16'hFFFF;
        endcase
    end

    // Second level: select among the three mux outputs or output all ones
    always @(*) begin
        case(sel[3:2])
            2'b00: out = mux0_out; // sel = 0..2
            2'b01: out = mux1_out; // sel = 4..6
            2'b10: out = mux2_out; // sel = 8..10
            default: out = 16'hFFFF; // sel = 12..15
        endcase

        // Handle invalid sel values: only 0..8 valid
        if(sel > 4'd8)
            out = 16'hFFFF;
    end

endmodule