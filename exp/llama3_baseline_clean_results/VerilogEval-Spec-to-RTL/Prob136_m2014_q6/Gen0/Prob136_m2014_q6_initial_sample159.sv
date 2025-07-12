module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [2:0] state;
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: if (w) state <= A; else state <= B;
            B: if (w) state <= D; else state <= C;
            C: if (w) state <= D; else state <= E;
            D: if (w) state <= A; else state <= F;
            E: if (w) state <= D; else state <= E;
            F: if (w) state <= D; else state <= C;
        endcase
    end
end

always @(*) begin
    case (state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
    endcase
end

endmodule