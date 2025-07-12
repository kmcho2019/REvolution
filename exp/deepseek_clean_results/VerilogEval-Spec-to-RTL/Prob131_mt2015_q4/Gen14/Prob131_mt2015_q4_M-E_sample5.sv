module TimeMultiplexedTop(
    input x,
    input y,
    input clk,
    output reg z
);
    reg phase;  // 0 for Module A phase, 1 for Module B phase
    reg a_out, b_out;
    reg or_out, and_out;
    
    always @(posedge clk) begin
        phase <= ~phase;
        
        if (~phase) begin
            // Module A phase: z = (x^y) & x
            a_out <= (x ^ y) & x;
            or_out <= a_out | b_out;
        end
        else begin
            // Module B phase: z = ~(x ^ y) (from waveform analysis)
            b_out <= ~(x ^ y);
            and_out <= a_out & b_out;
        end
        
        // Final XOR combination
        z <= or_out ^ and_out;
    end
    
    initial begin
        phase = 0;
        a_out = 0;
        b_out = 1;  // Initial state from waveform (z=1 when x=0,y=0)
    end
endmodule