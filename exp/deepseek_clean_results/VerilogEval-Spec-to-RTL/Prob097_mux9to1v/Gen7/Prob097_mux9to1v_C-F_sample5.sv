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

parameter DEFAULT_VAL = 16'hFFFF;

always @(*) begin
    case (sel)
        4'd0: out = a;
        4'd1: out = b;
        4'd2: out = c;
        4'd3: out = d;
        4'd4: out = e;
        4'd5: out = f;
        4'd6: out = g;
        4'd7: out = h;
        4'd8: out = i;
        default: out = DEFAULT_VAL; // sel 9-15
    endcase
end

/* Implementation Notes:
   - Current implementation prioritizes readability and maintainability
   - For timing optimization: Consider hierarchical muxing (2 stages of 3:1 muxes)
   - For power optimization: Gate inputs when sel > 8 to reduce switching
   - For area optimization: Explore tri-state implementation if supported by target technology
*/

endmodule