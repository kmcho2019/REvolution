module TopModule(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);
    // State encoding
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    always @(*) begin
        // Default outputs
        next_state = 4'b0000;
        out = 1'b0;

        // Output logic (Moore)
        out = D;

        // Next state logic
        // For each state, determine next state based on input
        if (A) begin
            next_state = in ? 4'b0010 : 4'b0001; // B : A
        end else if (B) begin
            next_state = in ? 4'b0010 : 4'b0100; // B : C
        end else if (C) begin
            next_state = in ? 4'b1000 : 4'b0001; // D : A
        end else if (D) begin
            next_state = in ? 4'b0010 : 4'b0100; // B : C
        end
    end
endmodule