module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // Previous input values
    reg [31:0] prev_in;
    
    // Detection registers (persistent until reset)
    reg [31:0] detected;
    
    assign out = detected;
    
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            detected <= 32'b0;
        end
        else begin
            // Update previous input
            prev_in <= in;
            
            // Set detection bits where we see falling edges
            detected <= detected | (prev_in & ~in);
        end
    end

endmodule