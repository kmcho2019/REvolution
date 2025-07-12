module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [2:0] {
        A  = 3'd0, // waiting for s=1
        B0 = 3'd1, // first w sample (count=0)
        B1 = 3'd2, // second w sample (count=1)
        B2 = 3'd3, // third w sample (count=2)
        B3 = 3'd4  // output cycle (decide z)
    } state_t;

    state_t state, next_state;
    reg [1:0] count; // count number of w=1 in current 3-cycle group (max 3)

    // Sequential logic: state and count update, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 0;
            z <= 0;
        end else begin
            state <= next_state;
            if (state == A) begin
                count <= 0;
                z <= 0;
            end else if (state == B3) begin
                // output depends on count == 2
                z <= (count == 2) ? 1'b1 : 1'b0;
                count <= 0; // reset count after output
            end else begin
                // In B0, B1, B2 accumulate count of w=1
                if (w)
                    count <= count + 1;
                // else count unchanged
                z <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = (s == 1'b1) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule