module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states as an enum
enum {A, B, C, D, E, F} state, next_state;

// Set the output z based on the current state
always_comb begin
    case (state)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Update the current state based on the input 'w' and the current state
always_ff @(posedge clk or posedge reset) begin
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

endmodule