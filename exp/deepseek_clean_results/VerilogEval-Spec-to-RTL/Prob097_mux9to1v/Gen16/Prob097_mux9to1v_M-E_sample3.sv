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

// Intermediate mux outputs
wire [15:0] mux1_out, mux2_out, mux3_out;

// First level muxes (3:1)
assign mux1_out = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b : c;

assign mux2_out = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e : f;

assign mux3_out = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h : i;

// Top level selection
always @(*) begin
    if (sel[3]) begin
        // Priority detection of invalid cases (sel >= 8)
        out = 16'hFFFF;
    end else begin
        case (sel[2])
            1'b0: out = (sel[1:0] == 2'd3) ? 16'hFFFF : mux1_out; // a-c
            1'b1: out = (sel[1:0] == 2'd3) ? mux3_out : mux2_out; // d-i
        endcase
    end
end

/* Implementation Notes:
   - Hierarchical structure reduces maximum fan-in to 3:1
   - sel[3] quickly detects invalid cases (sel >= 9)
   - Default value handled at top level
   - Clean separation between valid and invalid cases
*/

endmodule