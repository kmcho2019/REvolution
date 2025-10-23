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
    output reg [15:0] out
);

    wire [15:0] mux1_out, mux2_out;

    // First 4-to-1 multiplexer
    always @(*) begin
        case (sel[1:0])
            2'd0: mux1_out = a;
            2'd1: mux1_out = b;
            2'd2: mux1_out = c;
            2'd3: mux1_out = d;
            default: mux1_out = 16'h0;
        endcase
    end

    // Second 4-to-1 multiplexer
    always @(*) begin
        case (sel[1:0])
            2'd0: mux2_out = e;
            2'd1: mux2_out = f;
            2'd2: mux2_out = g;
            2'd3: mux2_out = h;
            default: mux2_out = 16'h0;
        endcase
    end

    // Final 2-to-1 multiplexer
    always @(*) begin
        case (sel[3:2])
            2'd0: out = mux1_out;
            2'd1: out = mux2_out;
            2'd2: out = i;
            default: out = 16'hFFFF;
        endcase
    end

endmodule