module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

// Combinational logic to detect transition
wire [31:0] transition_detected = ~in & prev_in;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        // Update prev_in for the next cycle
        prev_in <= in;
        
        // Update out_reg based on detected transitions
        out_reg <= out_reg | transition_detected;
    end
end

assign out = out_reg;

endmodule