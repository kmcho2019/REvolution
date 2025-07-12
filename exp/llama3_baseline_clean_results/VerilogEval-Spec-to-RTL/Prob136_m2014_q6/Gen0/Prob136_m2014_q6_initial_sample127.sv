module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);
    reg [2:0] state, next_state;

    // Define states
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            state <= next_state;
            case (state)
                A: z <= 0;
                B: z <= 0;
                C: z <= 0;
                D: z <= 0;
                E: z <= 1;
                F: z <= 1;
                default: z <= 0;
            endcase
        end
    end
endmodule