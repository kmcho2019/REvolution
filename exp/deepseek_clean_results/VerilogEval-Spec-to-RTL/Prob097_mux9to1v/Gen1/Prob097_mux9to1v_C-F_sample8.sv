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

// Internal signals
reg [15:0] mux_out;

// Combinational logic using parallel bit-sliced approach
always @(*) begin
    case (sel)
        4'd0: mux_out = a;
        4'd1: mux_out = b;
        4'd2: mux_out = c;
        4'd3: mux_out = d;
        4'd4: mux_out = e;
        4'd5: mux_out = f;
        4'd6: mux_out = g;
        4'd7: mux_out = h;
        4'd8: mux_out = i;
        default: mux_out = 16'hFFFF; // sel = 9 to 15
        // Note: For power optimization, could gate this when unused
    endcase
end

// Registered output for better timing
always @(*) begin
    out = mux_out;
end

endmodule