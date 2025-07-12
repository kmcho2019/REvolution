module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding with output hint in comments
    parameter A = 3'b000; // z=0
    parameter B = 3'b001; // z=0
    parameter C = 3'b010; // z=0
    parameter D = 3'b011; // z=0
    parameter E = 3'b100; // z=1
    parameter F = 3'b101; // z=1

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end
        else begin
            case (state)
                A: begin
                    state <= w ? A : B;
                    z <= 0;
                end
                B: begin
                    state <= w ? D : C;
                    z <= 0;
                end
                C: begin
                    state <= w ? D : E;
                    z <= 0;
                end
                D: begin
                    state <= w ? A : F;
                    z <= 0;
                end
                E: begin
                    state <= w ? D : E;
                    z <= 1;
                end
                F: begin
                    state <= w ? D : C;
                    z <= 1;
                end
                default: begin // should never happen
                    state <= A;
                    z <= 0;
                end
            endcase
        end
    end

endmodule