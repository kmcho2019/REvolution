module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 3 bits for clarity
    typedef enum logic [2:0] {
        A  = 3'd0,  // wait for s=1
        B0 = 3'd1,  // sample w #1
        B1 = 3'd2,  // sample w #2
        B2 = 3'd3,  // sample w #3
        Z  = 3'd4   // output assert cycle
    } state_t;

    state_t state, next_state;
    reg [1:0] count;  // counter for number of w=1 in sampling window (max 3)

    // Sequential logic: state and count update, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count <= 2'd0;
            z     <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                A: begin
                    count <= 2'd0;
                    z     <= 1'b0;
                end

                B0, B1, B2: begin
                    // Increment count by w
                    count <= count + w;
                    z <= 1'b0;
                end

                Z: begin
                    // Output asserted cycle
                    z <= (count == 2);
                    count <= 2'd0; // reset count for next window
                end

                default: begin
                    count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case(state)
            A:  next_state = (s == 1'b1) ? B0 : A;
            B0: next_state = B1;
            B1: next_state = B2;
            B2: next_state = Z;
            Z:  next_state = B0;
            default: next_state = A;
        endcase
    end

endmodule