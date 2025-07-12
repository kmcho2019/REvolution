module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam A = 2'b00; // Idle
    localparam B = 2'b01; // Grant device 0
    localparam C = 2'b10; // Grant device 1

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            A: begin
                if (r[0])
                    next_state = B;
                else if (r[1])
                    next_state = C;
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
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: grant signals for devices 0,1,2 with priority
    // If in state B, g0=1; in C, g1=1; otherwise grant device 2 if requested and no higher priority grant
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == A) && (r[2]) && !(r[0] || r[1]);

endmodule