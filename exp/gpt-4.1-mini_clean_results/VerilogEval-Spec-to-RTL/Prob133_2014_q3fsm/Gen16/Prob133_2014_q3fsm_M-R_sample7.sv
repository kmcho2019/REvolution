module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, state_next;

    reg [1:0] cycle_cnt;
    reg [1:0] w_accum;

    // Sequential block for state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= state_next;

            if (state_next == B) begin
                if (cycle_cnt == 2) begin
                    // After counting 3 cycles, reset counters
                    cycle_cnt <= 2'd0;
                    w_accum <= 2'd0;
                end else begin
                    cycle_cnt <= cycle_cnt + 2'd1;
                    w_accum <= w_accum + w;
                end
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end

            // Output z registered one cycle after window ends
            if (state == B && cycle_cnt == 2) begin
                z <= ((w_accum + w) == 2);
            end else begin
                z <= 1'b0;
            end
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s)
                    state_next = B;
                else
                    state_next = A;
            end
            B: begin
                state_next = B;
            end
            default: state_next = A;
        endcase
    end

endmodule