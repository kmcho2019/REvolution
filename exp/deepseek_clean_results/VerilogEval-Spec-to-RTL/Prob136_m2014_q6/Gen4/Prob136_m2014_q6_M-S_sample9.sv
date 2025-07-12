module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b010,
                    D = 3'b011,
                    E = 3'b100,
                    F = 3'b101;

    reg [2:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
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

    // Output is 1 for states E and F (100 and 101)
    assign z = (state == E) | (state == F);

endmodule