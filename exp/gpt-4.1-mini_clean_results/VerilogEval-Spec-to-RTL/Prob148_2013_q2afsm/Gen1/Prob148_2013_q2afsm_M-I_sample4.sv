module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding for 4 states
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

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
    end

    // Output logic combinational
    always @(*) begin
        case (state)
            B: g = 3'b001;
            C: g = 3'b010;
            D: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule