module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A  = 2'd0,
        B0 = 2'd1,
        B1 = 2'd2,
        B2 = 2'd3
    } state_t;

    state_t state, next_state;

    reg [1:0] w_count, next_w_count; // counts number of w=1 in current window
    reg z_next;

    // Output z is updated one cycle after B2 state sampling

    always @(*) begin
        // Defaults
        next_state = state;
        next_w_count = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: begin
                // Sample w in first cycle
                next_w_count = (w) ? 2'd1 : 2'd0;
                z_next = 1'b0;
                next_state = B1;
            end
            B1: begin
                // Sample w in second cycle
                next_w_count = w_count + (w ? 1 : 0);
                z_next = 1'b0;
                next_state = B2;
            end
            B2: begin
                // Sample w in third cycle
                next_w_count = w_count + (w ? 1 : 0);
                // Output z depends on exactly two w=1 in previous 3 cycles
                z_next = ((w_count + (w ? 1 : 0)) == 2);
                next_w_count = 2'd0; // Reset count for next window
                next_state = B0;
            end
            default: begin
                next_state = A;
                next_w_count = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            z <= z_next;
        end
    end

endmodule