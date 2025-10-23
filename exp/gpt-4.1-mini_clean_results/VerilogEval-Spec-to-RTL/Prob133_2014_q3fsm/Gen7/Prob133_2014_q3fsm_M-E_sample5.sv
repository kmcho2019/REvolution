module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 2 bits needed for 4 states (A, B0, B1, B2)
    typedef enum reg [1:0] {
        A  = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // count number of w=1 samples in the current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                A: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
                B0, B1: begin
                    // Accumulate w count during first two sampling states
                    w_count <= w_count + w;
                    z <= 1'b0;
                end
                B2: begin
                    // Last sample in window, add w to w_count, then output z next cycle
                    w_count <= 2'd0; // reset for next window
                    // output z one cycle after finishing count: evaluate using current w_count + w
                    z <= (w_count + w == 2) ? 1'b1 : 1'b0;
                end
                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            A:  next_state = (s) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule