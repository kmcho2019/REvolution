module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] in_reg;  // stores input for edge detection
    reg [31:0] out_reg; // holds detected falling edges
    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            in_reg <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Detect falling edges (1->0) and maintain state
            out_reg <= out_reg | (in_reg & ~in);
            in_reg <= in;
        end
    end

endmodule