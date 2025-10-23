module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding for clarity
    // A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic using one-hot encoding and explicit transitions
    always @(*) begin
        // Default no change
        next_state = 4'b0000;

        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: next_state = A; // Safe fallback
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic synchronous with state register
    always @(posedge clk) begin
        // Output = 1 only in state D, else 0
        if (reset)
            out <= 1'b0;
        else if (state == D)
            out <= 1'b1;
        else
            out <= 1'b0;
    end

endmodule