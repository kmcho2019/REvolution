module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 2 bits for 4 states
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state; // default hold current state
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
                if (~r[0])
                    next_state = A;
            end
            C: begin
                if (~r[1])
                    next_state = A;
            end
            D: begin
                if (~r[2])
                    next_state = A;
            end
        endcase
    end

    // Output combinational assignment based on state (no registers)
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule