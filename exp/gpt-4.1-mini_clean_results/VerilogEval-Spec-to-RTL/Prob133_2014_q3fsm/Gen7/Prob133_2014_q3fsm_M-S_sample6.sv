module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // Two states: A (waiting for s=1), B (counting w)
    typedef enum logic {A, B} state_t;
    state_t state, next_state;

    reg [2:0] w_shift;  // shift register holding last 3 w inputs
    reg [1:0] cycle_count; // counts how many w inputs shifted (max 3)

    // Function to count number of ones in 3-bit vector
    function automatic [1:0] popcount3(input [2:0] bits);
        integer i;
        popcount3 = 0;
        for (i = 0; i < 3; i = i +1)
            popcount3 = popcount3 + bits[i];
    endfunction

    always @(*) begin
        next_state = state;
        z = 1'b0; // default output zero

        case(state)
            A: begin
                if (s)
                    next_state = B;
            end
            B: begin
                // output z=1 only when 3 inputs have been shifted and popcount==2
                if (cycle_count == 3 && popcount3(w_shift) == 2)
                    z = 1'b1;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_shift <= 3'b0;
            cycle_count <= 0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                A: begin
                    w_shift <= 3'b0;
                    cycle_count <= 0;
                    z <= 1'b0;
                end
                B: begin
                    w_shift <= {w_shift[1:0], w};   // shift in new w
                    cycle_count <= (cycle_count < 3) ? cycle_count + 1 : 3;

                    // output z assigned combinationally in next_state logic;
                    // register to hold z updated after posedge clk
                    // so assign z here only to keep registered output consistent
                    z <= (cycle_count == 3 && popcount3(w_shift) == 2) ? 1'b1 : 1'b0;
                end
            endcase
        end
    end

endmodule