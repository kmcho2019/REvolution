module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // stores input from previous cycle
    reg [31:0] out_reg;  // holds detected falling edges
    
    assign out = out_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            // Detect falling edges and maintain state until reset
            out_reg <= out_reg | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule