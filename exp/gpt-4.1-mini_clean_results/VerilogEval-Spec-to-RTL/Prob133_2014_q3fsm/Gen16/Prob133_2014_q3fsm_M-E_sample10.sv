module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        A  = 2'b00,
        C0 = 2'b01,
        C1 = 2'b10,
        C2 = 2'b11
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // counts number of w=1 in current 3-cycle window

    // State and w_count update
    always @(posedge clk) begin
        if (reset) begin
            state   <= A;
            w_count <= 2'd0;
            z       <= 1'b0;
        end else begin
            state <= next_state;
            // Update w_count only in counting states
            if (state != A) begin
                if (state != C2) begin
                    w_count <= w_count + w;
                end else begin
                    w_count <= 2'd0; // reset after completing 3rd cycle count
                end
            end else begin
                w_count <= 2'd0;
            end

            // Output logic: z asserted only after finishing counting 3 cycles (in C2)
            if (state == C2)
                z <= (w_count + w == 2) ? 1'b1 : 1'b0;
            else
                z <= 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A:  next_state = s ? C0 : A;
            C0: next_state = C1;
            C1: next_state = C2;
            C2: next_state = C0;
            default: next_state = A;
        endcase
    end

endmodule