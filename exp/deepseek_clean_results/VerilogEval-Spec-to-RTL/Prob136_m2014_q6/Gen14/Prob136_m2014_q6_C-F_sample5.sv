module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding with single-bit transitions
    // between frequently connected states (A<->B, B<->D, etc.)
    parameter [2:0] A = 3'b000,  // z=0
                    B = 3'b001,  // z=0
                    C = 3'b011,  // z=0
                    D = 3'b010,  // z=0
                    E = 3'b110,  // z=1
                    F = 3'b100;  // z=1

    reg [2:0] state;

    // Combined state transition and storage
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? A : B;  // A stays or goes to B
                B: state <= w ? D : C;  // B goes to D or C
                C: state <= w ? D : E;  // C goes to D or E
                D: state <= w ? A : F; // D goes to A or F
                E: state <= w ? D : E; // E stays or goes to D
                F: state <= w ? D : C; // F goes to D or C
            endcase
        end
    end

    // Output is directly from state bit 2 (MSB)
    assign z = state[2];

endmodule