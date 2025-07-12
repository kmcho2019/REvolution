module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // State bits for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    reg [3:0] next_state_reg;

    always @(*) begin
        // Default all bits low
        next_state_reg = 4'b0000;

        // Next state logic based on current state and input
        if (A) begin
            if (in)
                next_state_reg = 4'b0010; // B
            else
                next_state_reg = 4'b0001; // A
        end else if (B) begin
            if (in)
                next_state_reg = 4'b0010; // B
            else
                next_state_reg = 4'b0100; // C
        end else if (C) begin
            if (in)
                next_state_reg = 4'b1000; // D
            else
                next_state_reg = 4'b0001; // A
        end else if (D) begin
            if (in)
                next_state_reg = 4'b0010; // B
            else
                next_state_reg = 4'b0100; // C
        end
    end

    assign next_state = next_state_reg;

    // Output logic: output is 1 only in state D
    assign out = D;

endmodule