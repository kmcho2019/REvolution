module TopModule(
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
    reg [1:0] sample_count; // counts 0 to 3 samples
    reg [2:0] w_samples;    // shift register to hold last 3 w samples
    reg z_next;

    // Function to count bits set to 1 in a 3-bit vector
    function [1:0] count_ones_3bit;
        input [2:0] bits;
        begin
            count_ones_3bit = bits[0] + bits[1] + bits[2];
        end
    endfunction

    // Sequential logic: state, sample_count, w_samples, z update
    always @(posedge clk) begin
        if (reset) begin
            state        <= A;
            sample_count <= 2'd0;
            w_samples    <= 3'b000;
            z            <= 1'b0;
        end else begin
            state        <= next_state;
            z            <= z_next;

            if (state == A) begin
                // Reset sampling data when in A
                sample_count <= 2'd0;
                w_samples    <= 3'b000;
            end else begin
                // In B: shift in new w sample and update count
                if (sample_count < 3) begin
                    w_samples <= {w_samples[1:0], w}; // shift left and append w
                    sample_count <= sample_count + 1;
                end else begin
                    // After 3 samples, reset count and shift in new sample for next window
                    w_samples <= {w_samples[1:0], w};
                    sample_count <= 2'd1;
                end
            end
        end
    end

    // Combinational logic: next state and z_next
    always @(*) begin
        next_state = state;
        z_next = 1'b0;

        case (state)
            A: begin
                if (s)
                    next_state = B;
            end
            B: begin
                next_state = B;
                if (sample_count == 3) begin
                    // Evaluate number of 1's in w_samples
                    if (count_ones_3bit(w_samples) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;
                end else begin
                    z_next = 1'b0;
                end
            end
            default: begin
                next_state = A;
                z_next = 1'b0;
            end
        endcase
    end

endmodule