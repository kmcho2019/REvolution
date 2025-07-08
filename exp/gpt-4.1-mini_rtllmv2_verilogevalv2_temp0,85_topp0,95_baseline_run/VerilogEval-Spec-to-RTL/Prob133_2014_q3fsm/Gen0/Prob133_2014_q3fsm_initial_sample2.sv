module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count; // count number of w=1 in the 3-cycle window

    // State and w_count update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    w_count <= 2'b00;
                    z <= 0;
                end
                B0, B1, B2: begin
                    // Accumulate w count in each B state
                    w_count <= w_count + w;
                    z <= 0; // default output zero during counting cycles
                end
                default: begin
                    w_count <= 0;
                    z <= 0;
                end
            endcase

            // Set output z in cycle after B2 (i.e., when next_state is B0)
            // So, in the cycle of B2, compute z for next cycle
            if (state == B2) begin
                // If exactly two w=1 in 3 cycles, then z=1 in next cycle
                // But z is registered at posedge clk, so we can set z now, 
                // to be output in the next cycle.
                // We must delay z output by one cycle. So let's output z in B0 state.
                // We'll store the z to output in a register and assign in B0.
            end
        end
    end

    // To generate z output in cycle after counting, we store the result in a register
    reg z_next;
    always @(posedge clk) begin
        if (reset) begin
            z_next <= 0;
        end else begin
            if(state == B2) begin
                z_next <= (w_count + w == 2) ? 1 : 0; // add current w for third cycle count
            end else if(state == B0) begin
                // output the stored z_next in B0 cycle (the cycle after B2)
                z <= z_next;
            end else if(state == A) begin
                z <= 0;
                z_next <= 0;
            end else begin
                z <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: next_state = s ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule