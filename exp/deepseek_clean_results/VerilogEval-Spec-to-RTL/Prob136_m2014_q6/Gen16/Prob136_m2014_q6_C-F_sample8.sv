module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding with explicit parameters
    localparam [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] state;

    // Combined state transition and storage in single always block
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? A : B;  // A transitions
                B: state <= w ? D : C;  // B transitions
                C: state <= w ? D : E;  // C transitions
                D: state <= w ? A : F;  // D transitions
                E: state <= w ? D : E;  // E transitions
                F: state <= w ? D : C;  // F transitions
            endcase
        end
    end

    // Direct output assignment from state bit
    assign z = state[2];

endmodule