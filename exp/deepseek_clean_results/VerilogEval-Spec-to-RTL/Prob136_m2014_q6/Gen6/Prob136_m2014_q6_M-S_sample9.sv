module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Binary state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b010,
                    D = 3'b011,
                    E = 3'b100,
                    F = 3'b101;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end
        else begin
            case (state)
                A: state <= w ? A : B;
                B: state <= w ? D : C;
                C: state <= w ? D : E;
                D: state <= w ? A : F;
                E: state <= w ? D : E;
                F: state <= w ? D : C;
                default: state <= A;
            endcase
            
            // Output logic
            z <= (state == E) | (state == F);
        end
    end

endmodule