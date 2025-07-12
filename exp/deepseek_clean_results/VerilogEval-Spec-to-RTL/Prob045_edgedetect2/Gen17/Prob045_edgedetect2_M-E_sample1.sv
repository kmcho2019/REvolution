module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    // State registers: 1 means previous value was 1, 0 means previous was 0
    reg [7:0] prev_state;

    always @(posedge clk) begin
        // For each bit, detect if current input differs from previous state
        anyedge <= (in & ~prev_state) | (~in & prev_state);
        
        // Update state registers
        prev_state <= in;
    end

endmodule