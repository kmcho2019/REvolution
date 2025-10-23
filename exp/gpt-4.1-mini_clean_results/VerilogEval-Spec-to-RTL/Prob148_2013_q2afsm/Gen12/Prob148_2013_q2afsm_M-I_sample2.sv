module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding for 4 states
    localparam A = 4'b0001; // idle
    localparam B = 4'b0010; // grant device 0
    localparam C = 4'b0100; // grant device 1
    localparam D = 4'b1000; // grant device 2

    reg [3:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (1'b1)
            state[A]: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
            default:  next_state = A;
        endcase
    end

    // Combinational output logic for g (no register)
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule