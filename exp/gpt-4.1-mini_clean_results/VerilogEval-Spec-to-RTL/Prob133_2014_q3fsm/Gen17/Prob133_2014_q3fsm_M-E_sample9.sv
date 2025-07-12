module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam [1:0]
        A  = 2'd0,
        B0 = 2'd1,
        B1 = 2'd2,
        B2 = 2'd3;

    reg [1:0] state, next_state;
    reg [1:0] w_count, next_w_count;  // count of '1's in w samples (max 3 -> 2 bits suffice)

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= (state == B2) && (next_state == B0) && (w_count == 2'd2); 
            // z asserted when exiting B2 and exactly two w=1 sampled
            // This synchronously registers z at the clock edge following third sample
        end
    end

    always @(*) begin
        // Default assignments
        next_state = state;
        next_w_count = w_count;

        case (state)
            A: begin
                next_w_count = 2'b00;
                z = 1'b0; // output 0 in reset state and while waiting
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                next_w_count = w + 0;  // accumulate w (w is 1 bit, addition into 2 bits)
                next_state = B1;
            end

            B1: begin
                next_w_count = w_count + w;
                next_state = B2;
            end

            B2: begin
                next_w_count = 2'b00; // reset count for next 3-sample block
                next_state = B0;
            end

            default: begin
                next_state = A;
                next_w_count = 2'b00;
                z = 1'b0;
            end
        endcase
    end

endmodule