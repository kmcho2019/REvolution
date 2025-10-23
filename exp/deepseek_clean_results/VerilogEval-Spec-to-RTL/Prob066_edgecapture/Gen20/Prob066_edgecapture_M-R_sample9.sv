module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] out_reg;
    wire [31:0] falling_edge;
    
    assign falling_edge = prev_in & ~in;  // Detect 1->0 transitions
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            prev_in <= in;
            out_reg <= out_reg | falling_edge;  // Capture and maintain state
        end
    end

endmodule