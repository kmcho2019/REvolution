module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

typedef enum {A, B, C, D, E, F} state_type;
state_type current_state, next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        case(current_state)
            A: begin
                if(w) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
            B: begin
                if(w) begin
                    next_state <= D;
                end else begin
                    next_state <= C;
                end
            end
            C: begin
                if(w) begin
                    next_state <= D;
                end else begin
                    next_state <= E;
                end
            end
            D: begin
                if(w) begin
                    next_state <= A;
                end else begin
                    next_state <= F;
                end
            end
            E: begin
                if(w) begin
                    next_state <= D;
                end else begin
                    next_state <= E;
                end
            end
            F: begin
                if(w) begin
                    next_state <= D;
                end else begin
                    next_state <= C;
                end
            end
            default: next_state <= A;
        endcase
        current_state <= next_state;
    end
end

assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

endmodule