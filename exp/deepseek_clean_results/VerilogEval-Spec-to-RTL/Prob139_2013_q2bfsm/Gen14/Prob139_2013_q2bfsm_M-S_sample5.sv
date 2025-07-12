module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8;
reg [3:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        case (state)
            A: state <= B;
            B: state <= C;
            C: if (x) state <= D;
            D: if (!x) state <= E; else state <= D;
            E: if (x) state <= F; else state <= C;
            F: if (y) state <= H; else state <= G;
            G: if (y) state <= H; else state <= I;
            default: state <= state; // H and I stay until reset
        endcase
    end
end

assign f = (state == B);
assign g = (state == F) || (state == G) || (state == H);

endmodule