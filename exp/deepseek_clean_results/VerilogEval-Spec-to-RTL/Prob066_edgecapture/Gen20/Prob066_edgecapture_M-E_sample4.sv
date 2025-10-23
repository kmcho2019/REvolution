module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] edge_detect;
    reg [31:0] capture_reg;

    assign out = capture_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            edge_detect <= 32'b0;
            capture_reg <= 32'b0;
        end else begin
            prev_in <= in;
            edge_detect <= (prev_in ^ in) & prev_in;  // Falling edge detection
            capture_reg <= capture_reg | edge_detect;  // Permanent latching
        end
    end

endmodule