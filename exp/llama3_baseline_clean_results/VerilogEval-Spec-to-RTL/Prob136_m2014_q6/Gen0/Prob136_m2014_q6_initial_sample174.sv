module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

typedef enum {A, B, C, D, E, F} state_type;
reg [2:0] state, next_state;

always @(*) begin
    case (state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

always @(posedge clk or posedge reset) begin
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
        endcase
    end
end

endmodule