module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Declare states with named parameters (enumerated type style)
    typedef enum reg [1:0] {
        A = 2'b00, // Idle state
        B = 2'b01, // Grant device 0
        C = 2'b10, // Grant device 1
        D = 2'b11  // Grant device 2
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            state <= next_state;
            case (next_state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            B:
                next_state = r[0] ? B : A;
            C:
                next_state = r[1] ? C : A;
            D:
                next_state = r[2] ? D : A;
            default:
                next_state = A;
        endcase
    end

endmodule