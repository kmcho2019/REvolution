module TopModule #(
    parameter WIDTH = 16,
    parameter DEFAULT_VAL = {WIDTH{1'b1}}, // Configurable default
    parameter PIPELINE_OUT = 0             // Optional output register
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [WIDTH-1:0] c,
    input  [WIDTH-1:0] d,
    input  [WIDTH-1:0] e,
    input  [WIDTH-1:0] f,
    input  [WIDTH-1:0] g,
    input  [WIDTH-1:0] h,
    input  [WIDTH-1:0] i,
    input  [3:0]       sel,
    output [WIDTH-1:0] out
);

`default_nettype none

// Hierarchical muxing reduces area vs flat 9:1 mux
wire [WIDTH-1:0] mux_stage1 [0:2];
wire [WIDTH-1:0] mux_stage2;

// First stage: 3 groups of 3 inputs
assign mux_stage1[0] = (sel[1:0] == 2'd0) ? a :
                       (sel[1:0] == 2'd1) ? b : c;
assign mux_stage1[1] = (sel[1:0] == 2'd0) ? d :
                       (sel[1:0] == 2'd1) ? e : f;
assign mux_stage1[2] = (sel[1:0] == 2'd0) ? g :
                       (sel[1:0] == 2'd1) ? h : i;

// Second stage: select between the 3 groups
assign mux_stage2 = (sel[3:2] == 2'd0) ? mux_stage1[0] :
                    (sel[3:2] == 2'd1) ? mux_stage1[1] :
                    (sel[3:2] == 2'd2) ? mux_stage1[2] : DEFAULT_VAL;

// Optional output register for timing
generate
    if (PIPELINE_OUT) begin
        reg [WIDTH-1:0] out_reg;
        always @(posedge clk) out_reg <= mux_stage2;
        assign out = out_reg;
    end else begin
        assign out = mux_stage2;
    end
endgenerate

endmodule