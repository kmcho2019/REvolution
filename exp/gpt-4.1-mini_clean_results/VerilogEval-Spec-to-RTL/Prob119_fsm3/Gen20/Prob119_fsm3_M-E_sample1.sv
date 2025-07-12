module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding: Each state is one bit
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;  // Reset to state A
        else
            state <= next_state;
    end

    // Next state and output logic combinational
    always @(*) begin
        // Default values
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
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
                // Safe state fallback (shouldn't happen)
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule