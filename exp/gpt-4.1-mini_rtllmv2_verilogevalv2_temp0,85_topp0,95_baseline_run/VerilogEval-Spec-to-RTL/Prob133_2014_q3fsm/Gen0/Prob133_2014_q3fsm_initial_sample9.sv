module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A  = 3'b000,
        B0 = 3'b001,
        B1 = 3'b010,
        B2 = 3'b011,
        B3 = 3'b100
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // counts number of times w=1 in 3 cycles

    // State register and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Update w_count in B states except B3
            if (state == B0 || state == B1 || state == B2) begin
                w_count <= w_count + w;
                z <= 1'b0;
            end else if (state == B3) begin
                // At B3, set z=1 if exactly 2 w=1's in previous 3 cycles
                if (w_count == 2)
                    z <= 1'b1;
                else
                    z <= 1'b0;
                w_count <= 0; // reset count for next window
            end else begin
                // In state A, output z=0
                z <= 1'b0;
                w_count <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
                if (s == 1)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B3;
            B3: next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule