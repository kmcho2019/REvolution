module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A  = 3'd0,  // Reset/waiting state
        B1 = 3'd1,  // 1st w sampling cycle
        B2 = 3'd2,  // 2nd w sampling cycle
        B3 = 3'd3,  // 3rd w sampling cycle, output evaluation next cycle
        ZP = 3'd4   // Output z pulse cycle after counting three w cycles
    } state_t;

    reg [1:0] w_count; // count of number of w=1 in current 3-cycle window
    state_t state, next_state;
    reg [1:0] next_w_count;
    reg next_z;

    // Next state and output logic
    always @(*) begin
        next_state = state;
        next_w_count = w_count;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B1;
                else
                    next_state = A;
            end

            B1: begin
                // Sample w and add to count
                next_w_count = w_count + w;
                next_state = B2;
            end

            B2: begin
                // Sample w and add
                next_w_count = w_count + w;
                next_state = B3;
            end

            B3: begin
                // Sample w, add to count and decide next state
                next_w_count = w_count + w;

                // Move to ZP to output z one cycle
                next_state = ZP;
            end

            ZP: begin
                // Output pulse cycle for z, then restart counting window
                next_z = (w_count == 2) ? 1'b1 : 1'b0;
                next_w_count = 2'd0;
                next_state = B1;
            end

            default: begin
                next_state = A;
                next_w_count = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: update state, count, and output synchronously with reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            w_count <= next_w_count;
            // z is asserted only in ZP state for one cycle after counting
            z <= next_z;
        end
    end

endmodule