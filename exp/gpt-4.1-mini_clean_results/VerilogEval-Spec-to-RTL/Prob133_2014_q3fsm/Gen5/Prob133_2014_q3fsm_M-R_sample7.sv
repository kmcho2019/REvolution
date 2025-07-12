module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] { A = 1'b0, B = 1'b1 } state_t;
    state_t state, next_state;

    reg [1:0] cycle_count;
    reg [1:0] w_count;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = (s == 1'b1) ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    // Cycle count increment enable signal
    wire count_enable = (state == B);

    // Sequential logic: state and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                cycle_count <= 2'd0;
                w_count <= 2'd0;
                z <= 1'b0;
            end else if (state == B) begin
                if (cycle_count < 2) begin
                    cycle_count <= cycle_count + 1'b1;
                    w_count <= w_count + w;
                    z <= 1'b0;
                end else begin
                    // cycle_count == 2, last cycle of 3
                    // Evaluate total count and generate z
                    z <= ((w_count + w) == 2) ? 1'b1 : 1'b0;
                    cycle_count <= 2'd0;
                    w_count <= 2'd0;
                end
            end else begin
                // Default safe reset for outputs
                z <= 1'b0;
                cycle_count <= 2'd0;
                w_count <= 2'd0;
            end
        end
    end

endmodule