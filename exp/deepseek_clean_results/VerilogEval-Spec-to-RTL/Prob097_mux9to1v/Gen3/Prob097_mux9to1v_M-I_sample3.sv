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

always @(*) begin
    if (sel > 4'd8) begin
        out = 16'hFFFF;  // Early exit for unused cases
    end else begin
        // Hierarchical mux implementation
        case (sel[2:0])
            3'd0: out = a;
            3'd1: out = b;
            3'd2: out = c;
            3'd3: out = d;
            3'd4: out = e;
            3'd5: out = f;
            3'd6: out = g;
            3'd7: out = (sel[3]) ? i : h;  // Use sel[3] to choose between h and i
        endcase
    end
end

endmodule