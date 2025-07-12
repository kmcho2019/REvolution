module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output      out
);

    // One-hot state bit aliases for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Combinational next_state logic inside always_comb block
    always @(*) begin
        // Default no next state active (safe default)
        next_state = 4'b0000;

        case (1'b1) // priority encoding on one-hot state
            A: begin
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0001; // A
            end
            B: begin
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            C: begin
                if (in)
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // A
            end
            D: begin
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
            end
            default: begin
                next_state = 4'b0001; // Default to A if no state active
            end
        endcase
    end

    // Output is 1 only in state D
    assign out = D;

endmodule