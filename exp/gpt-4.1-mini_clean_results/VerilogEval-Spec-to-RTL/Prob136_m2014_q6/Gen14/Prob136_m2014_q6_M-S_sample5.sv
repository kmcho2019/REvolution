module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    localparam [2:0] A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
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
                default: begin
                    state <= A;
                    z <= 0;
                end
            endcase
        end
    end

endmodule