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
    output [15:0] out
);

// Early detection of invalid selection for power optimization
wire valid_sel = (sel < 9);
reg [15:0] selected;

always @(*) begin
    if (!valid_sel) begin
        selected = 16'hFFFF; // Hardcoded default for invalid cases
    end else begin
        // Single-level case statement for better timing
        case (sel)
            4'd0: selected = a;
            4'd1: selected = b;
            4'd2: selected = c;
            4'd3: selected = d;
            4'd4: selected = e;
            4'd5: selected = f;
            4'd6: selected = g;
            4'd7: selected = h;
            4'd8: selected = i;
            default: selected = 16'hFFFF; // Redundant but safe
        endcase
    end
end

assign out = selected; // Continuous assignment for cleaner code

/* Implementation Notes:
   - Combines best aspects of both examples:
     1. Early valid_sel detection from both examples
     2. Single-level case statement from Example 1
     3. Continuous assignment from Example 2
   - Optimized for timing, power, and area
   - Clean, readable structure
*/

endmodule