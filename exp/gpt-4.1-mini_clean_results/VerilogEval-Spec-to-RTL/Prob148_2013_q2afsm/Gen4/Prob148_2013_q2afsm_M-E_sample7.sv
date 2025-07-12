module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary)
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            A: begin
                // Priority: r[0] > r[1] > r[2]
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
                // Stay in B if r[0] asserted, else return to A
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end

            C: begin
                // Stay in C if r[1] asserted, else return to A
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end

            D: begin
                // Stay in D if r[2] asserted, else return to A
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            default: next_state = A;  // Safety fallback
        endcase
    end

    // Output logic combinational
    always @(*) begin
        case (state)
            B: g = 3'b001;  // Grant device 0
            C: g = 3'b010;  // Grant device 1
            D: g = 3'b100;  // Grant device 2
            default: g = 3'b000; // No grant
        endcase
    end

endmodule