module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // Use combinational always block with casez for one-hot states
    always @(*) begin
        // Default assignments to avoid latches
        next_state = 4'b0000;
        out = 1'b0;

        casez ({state, in})
            // Concatenate state and input for easy pattern matching:
            // state: 4 bits one-hot, in: 1 bit at LSB

            // State A (0001)
            5'b0001_0: begin
                next_state = 4'b0001; // stay in A
                out = 1'b0;
            end
            5'b0001_1: begin
                next_state = 4'b0010; // go to B
                out = 1'b0;
            end

            // State B (0010)
            5'b0010_0: begin
                next_state = 4'b0100; // go to C
                out = 1'b0;
            end
            5'b0010_1: begin
                next_state = 4'b0010; // stay in B
                out = 1'b0;
            end

            // State C (0100)
            5'b0100_0: begin
                next_state = 4'b0001; // go to A
                out = 1'b0;
            end
            5'b0100_1: begin
                next_state = 4'b1000; // go to D
                out = 1'b0;
            end

            // State D (1000)
            5'b1000_0: begin
                next_state = 4'b0100; // go to C
                out = 1'b1;
            end
            5'b1000_1: begin
                next_state = 4'b0010; // go to B
                out = 1'b1;
            end

            // Default: should not happen if one-hot, keep outputs low
            default: begin
                next_state = 4'b0000;
                out = 1'b0;
            end
        endcase
    end

endmodule