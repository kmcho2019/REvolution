module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;

localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (~w) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            B: begin
                if (~w) begin
                    state <= C;
                end else begin
                    state <= D;
                end
            end
            C: begin
                if (~w) begin
                    state <= E;
                end else begin
                    state <= D;
                end
            end
            D: begin
                if (~w) begin
                    state <= F;
                end else begin
                    state <= A;
                end
            end
            E: begin
                if (~w) begin
                    state <= E;
                end else begin
                    state <= D;
                end
            end
            F: begin
                if (~w) begin
                    state <= C;
                end else begin
                    state <= D;
                end
            end
            default: state <= A; // Unused states default back to A
        endcase
    end
end

always @(*) begin
    case (state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0; // Unused states default to 0
    endcase
end

endmodule