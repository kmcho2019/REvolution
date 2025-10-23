module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding (MSB indicates z output)
    parameter A = 3'b000;
    parameter B = 3'b001;
    parameter C = 3'b010;
    parameter D = 3'b011;
    parameter E = 3'b100;
    parameter F = 3'b101;

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
            z <= state[2]; // E and F have MSB=1
        end
    end

endmodule