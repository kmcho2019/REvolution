module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits for minimal area)
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] current_state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic - priority encoded (r0 > r1 > r2)
    always @(*) begin
        case (current_state)
            A: begin
                if (r[0])       next_state = B;
                else if (r[1])  next_state = C;
                else if (r[2])  next_state = D;
                else            next_state = A;
            end
            B: next_state = r[0] ? B : A;  // Stay if r0, else return to A
            C: next_state = r[1] ? C : A;  // Stay if r1, else return to A
            D: next_state = r[2] ? D : A;  // Stay if r2, else return to A
        endcase
    end

    // Output logic - combinational (1-hot when in grant states)
    assign g = {current_state == D,  // g2
                current_state == C,  // g1
                current_state == B}; // g0

endmodule