module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding for FSM
    typedef enum reg [1:0] {
        A  = 2'b00,
        B0 = 2'b01,
        B1 = 2'b10,
        B2 = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] w_shift;  // shift register holding last 3 w samples
    reg z_next;

    // Combinational logic for next state and z_next
    always @(*) begin
        z_next = 1'b0;  // default output zero
        case(state)
            A: begin
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = B0;
            default: next_state = A;
        endcase

        // z asserted only in A or B0 cycle after collecting 3 samples in B2
        if (state == B2) begin
            // after shifting in w this cycle, count ones in w_shift[2:0] 
            // But since w_shift updates on posedge, z is delayed to next cycle,
            // so z asserted when state==B0 (next_state after B2)
            z_next = 1'b0;
        end else if (state == B0) begin
            // z is generated here for the previous 3-cycle window collected during B0 (after B2)
            // count ones in w_shift (which has last 3 samples)
            z_next = (w_shift[0] + w_shift[1] + w_shift[2]) == 2;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            case (state)
                A: w_shift <= 3'b000; // clear samples when in A
                B0, B1, B2: begin
                    // Shift left and input new w bit each cycle
                    w_shift <= {w_shift[1:0], w};
                end
                default: w_shift <= 3'b000;
            endcase
        end
    end

endmodule