module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Optimized state encoding
    localparam A = 2'b00;
    localparam B = 2'b01;  // g0 active
    localparam C = 2'b10;  // g1 active
    localparam D = 2'b11;  // g2 active

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state) // synthesis parallel_case
            A: begin
                if (r[0])       next_state = B;
                else if (r[1])  next_state = C;
                else if (r[2]) next_state = D;
                else            next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    // Optimized output logic
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 : 3'b000;

endmodule