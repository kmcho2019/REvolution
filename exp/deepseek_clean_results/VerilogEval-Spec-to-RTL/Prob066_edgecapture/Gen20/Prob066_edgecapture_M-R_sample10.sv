module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;  // stores input from previous cycle
    reg [31:0] out_reg;  // holds detected falling edges
    
    // Output assignment
    assign out = out_reg;

    // Sequential logic for storing previous input
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Sequential logic for edge detection and output
    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 32'b0;
        end else begin
            // For each bit: if we had 1 last cycle and 0 this cycle, set output
            // OR with previous output to maintain state
            out_reg <= out_reg | (prev_in & ~in);
        end
    end

endmodule