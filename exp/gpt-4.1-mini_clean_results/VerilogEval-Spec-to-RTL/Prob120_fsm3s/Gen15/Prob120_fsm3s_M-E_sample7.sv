module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state and output combinational logic
    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case(state)
            A: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                out = 1'b0;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                out = 1'b0;
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                out = 1'b1;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // Sequential logic with synchronous active high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule