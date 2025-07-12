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

// First level mux outputs
wire [15:0] mux1_out, mux2_out, mux3_out;

// First level multiplexers (3-to-1)
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

// Second level mux (3-to-1) with priority encoding
always @(*) begin
    if (sel[3]) begin
        out = 16'hFFFF;  // sel >= 8 (invalid cases)
    end else if (sel[2]) begin
        out = mux3_out;  // sel 4-7 (g,h,i)
    end else begin
        // Select between first two groups
        case (sel[1:0])
            2'b00: out = mux1_out;  // a,d
            2'b01: out = mux2_out;  // b,e
            2'b10: out = (sel[1:0] == 2'b10) ? mux1_out : mux2_out;  // c,f
            default: out = 16'hFFFF;
        endcase
    end
end

endmodule