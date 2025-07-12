module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum {A, B, C, D, E, F} state, next_state;

// Always block to handle state transitions
always @ (posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (w) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if (w) begin
                    state <= D;
                end else begin
                    state <= C;
                end
            end
            C: begin
                if (w) begin
                    state <= D;
                end else begin
                    state <= E;
                end
            end
            D: begin
                if (w) begin
                    state <= A;
                end else begin
                    state <= F;
                end
            end
            E: begin
                if (w) begin
                    state <= D;
                end else begin
                    state <= E;
                end
            end
            F: begin
                if (w) begin
                    state <= D;
                end else begin
                    state <= C;
                end
            end
        endcase
    end
end

// Output logic
always @ (state) begin
    case (state)
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule