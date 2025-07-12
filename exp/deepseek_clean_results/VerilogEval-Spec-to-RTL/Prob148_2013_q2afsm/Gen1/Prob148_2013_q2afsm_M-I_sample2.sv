module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] current_state, next_state;

    // State register (sequential logic)
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            A: begin
                if (r[0])          // Highest priority
                    next_state = B;
                else if (r[1])     // Medium priority
                    next_state = C;
                else if (r[2])     // Lowest priority (only when alone)
                    next_state = D;
                else
                    next_state = A;
            end
            B: next_state = r[0] ? B : A;  // Stay while r[0]=1
            C: next_state = r[1] ? C : A;   // Stay while r[1]=1
            D: next_state = r[2] ? D : A;   // Stay while r[2]=1
            default: next_state = A;
        endcase
    end

    // Output logic (combinational)
    assign g = (current_state == B) ? 3'b001 :
               (current_state == C) ? 3'b010 :
               (current_state == D) ? 3'b100 : 3'b000;

endmodule