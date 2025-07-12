module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Simplified state encoding (D removed)
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;

    reg [1:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Simplified next state logic
    always @(*) begin
        case (current_state)
            A: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            default: next_state = A;
        endcase
    end

    // Output logic remains simple
    assign g = (current_state == B) ? 3'b001 :
               (current_state == C) ? 3'b010 : 3'b000;

endmodule