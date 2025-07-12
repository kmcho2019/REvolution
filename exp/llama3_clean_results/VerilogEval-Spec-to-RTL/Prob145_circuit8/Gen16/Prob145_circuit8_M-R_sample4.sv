module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3
} state_t;

state_t state, nextState;

always @(posedge clock) begin
    state <= nextState;
end

always @(*) begin
    case(state)
        S0: begin
            if (a) begin
                nextState = S1;
                p = 1'b1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (a) begin
                nextState = S2;
                q = 1'b1;
            end else begin
                nextState = S1;
            end
        end
        S2: begin
            if (a) begin
                nextState = S2;
            end else begin
                nextState = S3;
                p = 1'b0;
            end
        end
        S3: begin
            if (a) begin
                nextState = S3;
            end else begin
                nextState = S0;
                q = 1'b0;
            end
        end
        default: begin
            nextState = S0;
        end
    endcase
end

initial begin
    state = S0;
    p = 1'b0;
    q = 1'b0;
end

endmodule