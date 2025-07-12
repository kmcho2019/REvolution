module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic {A, B} state_t;
    state_t state, next_state;

    reg [1:0] cycle_idx;  // counts cycles 0 to 2 in B
    reg [1:0] w_count;    // counts w=1 occurrences in current 3-cycle window

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_idx <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= 1'b0; // default no output

            case(state)
                A: begin
                    cycle_idx <= 2'd0;
                    w_count <= 2'd0;
                end
                B: begin
                    if (cycle_idx < 2) begin
                        cycle_idx <= cycle_idx + 1'b1;
                        w_count <= w_count + w;
                    end else begin
                        // On 3rd cycle: check count + current w
                        if ((w_count + w) == 2)
                            z <= 1'b1;
                        cycle_idx <= 2'd0;
                        w_count <= 2'd0;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule