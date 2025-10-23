module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized Gray-coded state encoding with improved transition patterns
    // z is now state[1] for better placement
    parameter [2:0] A = 3'b000,  // z=0
                    B = 3'b001,  // z=0
                    C = 3'b011,  // z=1
                    D = 3'b010,  // z=1
                    E = 3'b110,  // z=1
                    F = 3'b111;  // z=1

    reg [2:0] state;

    // State transition logic with optimized grouping
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
            endcase
        end
    end

    // Output assignment - now from bit 1 for better placement
    assign z = state[1];

endmodule