module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A = 2'b00; // idle, no grant
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case(state)
            A: begin
                // Priority: r[0], then r[1], then r[2]
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
                // stay in B if r0=1 else back to A
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end
            C: begin
                // stay in C if r1=1 else back to A
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end
            D: begin
                // stay in D if r2=1 else back to A
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end
            default: next_state = A; // safety fallback
        endcase
    end

    // Output logic for g signals, combinational
    always @(*) begin
        g = 3'b000;
        case(state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant
        endcase
    end

endmodule