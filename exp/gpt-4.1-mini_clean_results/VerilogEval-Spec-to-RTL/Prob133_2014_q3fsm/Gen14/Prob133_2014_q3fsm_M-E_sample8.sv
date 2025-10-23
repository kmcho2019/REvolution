module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);
    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] sample_count, next_sample_count; // count how many w samples collected (0-2)
    reg [2:0] w_samples, next_w_samples;       // shift register storing last three w samples

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            sample_count <= 2'b00;
            w_samples <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            sample_count <= next_sample_count;
            w_samples <= next_w_samples;
            z <= (state == B && sample_count == 2) && (popcount(next_w_samples) == 2);
        end
    end

    // Function to count set bits in 3-bit vector
    function [1:0] popcount;
        input [2:0] val;
        begin
            // Count bits set in val[2:0]
            popcount = val[0] + val[1] + val[2];
        end
    endfunction

    // Combinational logic for next state and shift register
    always @(*) begin
        next_state = state;
        next_sample_count = sample_count;
        next_w_samples = w_samples;

        case(state)
            A: begin
                // Reset sampling in state A
                next_sample_count = 2'b00;
                next_w_samples = 3'b000;
                if (s)
                    next_state = B;
            end
            B: begin
                if (sample_count == 2) begin
                    // After collecting 3 samples, reset sample count and w_samples for next group
                    // Shift in current w for next group start (restart counting from 1 sample)
                    next_sample_count = 2'b00;
                    next_w_samples = 3'b000; // clear; samples will be collected starting next cycle
                    // state stays B
                end else begin
                    // Shift w in and increment sample count
                    next_w_samples = {w_samples[1:0], w};
                    next_sample_count = sample_count + 1'b1;
                end
            end
            default: begin
                next_state = A;
                next_sample_count = 2'b00;
                next_w_samples = 3'b000;
            end
        endcase
    end

endmodule