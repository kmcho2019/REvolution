module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized Gray-coded state encoding with better transition patterns
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    D = 3'b011,
                    C = 3'b010,
                    E = 3'b110,
                    F = 3'b111;

    reg [2:0] state;

    // State transition logic - ordered by expected frequency
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end
        else begin
            case (state)
                A: state <= w ? A : B;
                D: state <= w ? A : F;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
            endcase
            
            // Registered output for reduced switching
            z <= state[2];
        end
    end

endmodule