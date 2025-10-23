module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits)
    typedef enum reg [1:0] {A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11} state_t;
    state_t state, next_state;

    // Combinational always block for next state and output logic
    always @(*) begin
        // Default assignments
        next_state = A;
        g = 3'b000;

        case(state)
            A: begin
                // Priority: device0 > device1 > device2
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            B: begin
                g = 3'b001; // grant device 0
                next_state = r[0] ? B : A;
            end

            C: begin
                g = 3'b010; // grant device 1
                next_state = r[1] ? C : A;
            end

            D: begin
                g = 3'b100; // grant device 2
                next_state = r[2] ? D : A;
            end

            default: begin
                next_state = A;
                g = 3'b000;
            end
        endcase
    end

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

endmodule