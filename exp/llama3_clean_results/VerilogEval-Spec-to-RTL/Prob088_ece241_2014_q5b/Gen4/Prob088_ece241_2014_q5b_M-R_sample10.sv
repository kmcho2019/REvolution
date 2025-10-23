module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

typedef enum logic [0:0] {
    A,
    B
} state_t;

state_t state, next_state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        A: begin
            z = 1'b0;
            if(x) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            z = 1'b1;
            if(!x) begin
                next_state = B;
            end else begin
                next_state = B;
            end
        end
        default: begin
            z = 1'bx;
            next_state = A;
        end
    endcase
end

endmodule