module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [0:0] { // only two states needed
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    reg [1:0] cycle_count;  // counts 0..2 cycles within a group of 3
    reg [1:0] w_count;      // counts number of w=1 in these 3 cycles
    reg       output_z;     // temporary output, registered for one cycle

    // Sequential logic: state and counters update, output registered
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
            output_z <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    output_z <= 1'b0;
                    z <= 1'b0;
                end
                B: begin
                    if (cycle_count < 2) begin
                        // Counting cycles: accumulate w_count
                        w_count <= w_count + w;
                        cycle_count <= cycle_count + 1'b1;
                        output_z <= 1'b0;
                        z <= 1'b0;
                    end else begin
                        // This is the 3rd counting cycle (cycle_count == 2)
                        w_count <= w_count + w;  // include last w
                        cycle_count <= 2'd0;     // reset for next group

                        output_z <= (w_count + w == 2); // output in next cycle
                        z <= output_z;          // z registered one cycle delayed
                        w_count <= 2'd0;        // clear count after output cycle
                    end
                end
                default: begin
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                    output_z <= 1'b0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: next_state = s ? B : A;
            B: next_state = B;  // stay in counting state indefinitely
            default: next_state = A;
        endcase
    end

endmodule