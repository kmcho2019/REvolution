module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    localparam A = 2'b00; // Idle, no grant
    localparam B = 2'b01; // Grant device 0
    localparam C = 2'b10; // Grant device 1
    localparam D = 2'b11; // Grant device 2

    reg [1:0] state, next_state;

    // Combinational next-state logic with priority and explicit conditions
    always @* begin
        case (state)
            A: begin
                if      (r[0])       next_state = B;          // Highest priority device 0
                else if (r[1])       next_state = C;          // Device 1 next priority
                else if (r[2])       next_state = D;          // Device 2 lowest priority
                else                 next_state = A;          // No requests, stay idle
            end
            B: next_state = r[0] ? B : A;                     // Stay granted if r0=1 else back to idle
            C: next_state = r[1] ? C : A;                     // Stay granted if r1=1 else back to idle
            D: next_state = r[2] ? D : A;                     // Stay granted if r2=1 else back to idle
            default: next_state = A;                           // Safe default
        endcase
    end

    // Sequential logic: state update with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Outputs derived from state: grant signals are one-hot encoded per state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule