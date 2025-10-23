module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding
    reg [3:0] state;
    parameter A = 4'b0001,
             B = 4'b0010,
             C = 4'b0100,
             D = 4'b1000;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end
        else begin
            // State transition logic
            state[0] <= (state[0] & ~in) | (state[2] & ~in);  // A stays or C->A
            state[1] <= (state[0] & in) | (state[1] & in) | (state[3] & in);  // A->B, B stays, D->B
            state[2] <= (state[1] & ~in) | (state[3] & ~in);  // B->C, D->C
            state[3] <= (state[2] & in);  // C->D

            // Registered output (Moore)
            out <= (state == D);
        end
    end

endmodule