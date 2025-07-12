module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State registers for each bit (0=last was low, 1=last was high)
    reg [7:0] bit_state;

    // Parallel state machines for each bit
    always @(posedge clk) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            // Update state machine
            bit_state[i] <= in[i];
            
            // Output logic: detect state change
            anyedge[i] <= (in[i] != bit_state[i]);
        end
    end

endmodule