module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

localparam A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        out <= 0;
    end else begin
        case (state)
            A: begin
                state <= in ? B : A;
                out <= 0;
            end
            B: begin
                state <= in ? B : C;
                out <= 0;
            end
            C: begin
                state <= in ? D : A;
                out <= 0;
            end
            D: begin
                state <= in ? B : C;
                out <= 1;
            end
            default: begin
                state <= A;
                out <= 0;
            end
        endcase
    end
end

endmodule