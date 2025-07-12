module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

typedef enum logic [1:0] {
    INIT,
    COUNT,
    RESET
} state_t;

state_t current_state;

always @(posedge clk) begin
    case (current_state)
        INIT: begin
            q <= 3'd4;
            current_state <= COUNT;
        end
        COUNT: begin
            if (a) begin
                current_state <= RESET;
            end else if (q == 3'd6) begin
                q <= 3'd0;
                current_state <= COUNT;
            end else begin
                q <= q + 1;
            end
        end
        RESET: begin
            q <= 3'd4;
            current_state <= COUNT;
        end
        default: begin
            current_state <= INIT;
        end
    endcase
end

initial begin
    current_state <= INIT;
end

endmodule