module TopModule (
    input         clk,      // Added clock for pipelining
    input         en,       // Enable for power gating
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

// Configurable default value - can be optimized for power
parameter DEFAULT_VAL = 16'hFFFF;

// Internal signal for combinational logic
reg [15:0] mux_out;

always @(*) begin
    // Binary decision structure for better synthesis
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
        default: mux_out = DEFAULT_VAL; // sel 9-15
    endcase
end

// Pipelined output register with clock gating
always @(posedge clk) begin
    if (en) begin
        out <= mux_out;
    end
end

endmodule