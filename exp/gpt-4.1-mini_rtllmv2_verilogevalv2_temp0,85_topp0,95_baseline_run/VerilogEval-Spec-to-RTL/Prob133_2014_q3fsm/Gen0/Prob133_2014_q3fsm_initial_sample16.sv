module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // Counter for number of w inputs examined (0 to 3)
    reg [1:0] w_count;

    // Counter for number of w=1 in current batch (0 to 3)
    reg [1:0] w_ones_count;

    // Register to hold output z, updated one cycle after counting 3 inputs
    reg z_next;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            w_ones_count <= 2'd0;
            z <= 1'b0;
            z_next <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            if (state == A) begin
                // In A, wait for s=1, no counting
                w_count <= 2'd0;
                w_ones_count <= 2'd0;
                z_next <= 1'b0;
            end else if (state == B) begin
                // In B, count w inputs
                if (w_count < 2'd3) begin
                    w_count <= w_count + 1;
                    if (w == 1'b1)
                        w_ones_count <= w_ones_count + 1;
                end else begin
                    // After 3 inputs, reset counter to start next batch
                    w_count <= 1;  // start counting new batch with current input
                    // Count current input as first in new batch
                    w_ones_count <= (w == 1'b1) ? 1 : 0;
                end

                // Update z_next only when we have just completed counting 3 inputs
                if (w_count == 2'd3) begin
                    z_next <= (w_ones_count == 2);
                end else begin
                    z_next <= 1'b0;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: next_state = (s == 1'b1) ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

endmodule