module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01; // grant r[0]
    parameter C = 2'b10; // grant r[1]
    parameter D = 2'b11; // grant r[2]

    reg [1:0] state, next_state;

    // State flip-flops with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin
        // Default outputs
        g = 3'b000;
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
            B: begin
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            default: next_state = A;
        endcase

        // Output based on next state (or current state)
        case (next_state)
            B: g = 3'b001;
            C: g = 3'b010;
            D: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule