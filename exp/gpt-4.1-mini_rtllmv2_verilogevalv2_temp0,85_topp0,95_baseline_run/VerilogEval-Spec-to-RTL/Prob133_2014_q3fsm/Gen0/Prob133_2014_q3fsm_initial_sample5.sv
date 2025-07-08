module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'b000,
        B0 = 3'b001,
        B1 = 3'b010,
        B2 = 3'b011,
        B3 = 3'b100
    } state_t;

    reg [2:0] state, next_state;
    reg [1:0] w_count; // counts number of w=1s in current 3-cycle window
    reg z_next;

    // Next state logic and output logic combinational
    always @(*) begin
        next_state = state;
        z_next = 1'b0;

        case(state)
            A: begin
                z_next = 1'b0;
                if (s == 1'b1)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // first cycle, record w
                next_state = B1;
            end

            B1: begin
                // second cycle
                next_state = B2;
            end

            B2: begin
                // third cycle
                next_state = B3;
            end

            B3: begin
                // Evaluate count, output z=1 if w_count == 2
                // Then go back to B0
                next_state = B0;
            end

            default: next_state = A;
        endcase
    end

    // Sequential logic: state update, count w's, output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;

            case(state)
                A: begin
                    w_count <= 2'b00;
                end

                B0: begin
                    // start counting w's in three cycles
                    w_count <= (w == 1'b1) ? 2'b01 : 2'b00;
                end

                B1: begin
                    // add w to count
                    w_count <= w_count + (w == 1'b1 ? 1'b1 : 1'b0);
                end

                B2: begin
                    // add w to count
                    w_count <= w_count + (w == 1'b1 ? 1'b1 : 1'b0);
                end

                B3: begin
                    // output z=1 if count == 2, else 0
                    z <= (w_count == 2) ? 1'b1 : 1'b0;
                    // reset count to zero for next window
                    w_count <= 2'b00;
                end

                default: begin
                    w_count <= 2'b00;
                    z <= 1'b0;
                end
            endcase
        end
    end
endmodule