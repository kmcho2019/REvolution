module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured;

    // Update captured bits when falling edge detected (prev=1, current=0)
    assign out = captured | (prev_in & ~in);

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Update captured bits (latch behavior)
            captured <= out;
        end
    end

endmodule