module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b100;

    reg [2:0] state;

    // State transition logic with unique case for optimal synthesis
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            unique case (state)
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
            endcase
        end
    end

    // Direct output assignment from state bit
    assign z = state[2];

endmodule