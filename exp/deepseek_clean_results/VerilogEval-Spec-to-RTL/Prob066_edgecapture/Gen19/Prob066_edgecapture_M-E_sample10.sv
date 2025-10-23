module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] out_reg;

    // Detect any bit changes
    wire [31:0] changed = prev_in ^ in;
    
    // Falling edge = changed AND was previously 1
    wire [31:0] falling_edge = changed & prev_in;

    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            prev_in <= in;
            out_reg <= out_reg | falling_edge;
        end
    end

endmodule