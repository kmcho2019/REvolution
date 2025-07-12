module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding: 2 bits
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with explicit priority in state A
    always @(*) begin
        case (state)
            A: begin
                if      (r[0]) next_state = B; // Highest priority request
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else           next_state = A;
            end
            B: next_state = r[0] ? B : A; // Stay granted while request held
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic combinationally derived from current state
    always @(*) begin
        case (state)
            B: g = 3'b001;
            C: g = 3'b010;
            D: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule