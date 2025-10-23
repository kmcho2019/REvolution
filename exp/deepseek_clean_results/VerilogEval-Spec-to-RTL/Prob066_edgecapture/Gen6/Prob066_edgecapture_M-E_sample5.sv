module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] capture;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            capture <= 32'b0;
        end
        else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Set capture bits when falling edge detected (1->0 transition)
            // Once set, bits stay set until reset
            capture <= capture | (prev_in & ~in);
        end
    end

    assign out = capture;

endmodule