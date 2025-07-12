module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Binary encoded states
    localparam A = 3'd0, B = 3'd1, C = 3'd2,
               D = 3'd3, E = 3'd4, F = 3'd5;

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
            endcase
            z <= (state == E) | (state == F);
        end
    end

endmodule