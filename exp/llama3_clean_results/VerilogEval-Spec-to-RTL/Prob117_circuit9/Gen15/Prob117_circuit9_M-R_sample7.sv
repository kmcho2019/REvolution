module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define states
enum logic [1:0] {IDLE, COUNT, RESET} state, next_state;

always @(*) begin
    case (state)
        IDLE: begin
            if (a) begin
                next_state = RESET;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT: begin
            if (a) begin
                next_state = RESET;
            end else if (q == 5) begin
                next_state = COUNT;
            end else begin
                next_state = COUNT;
            end
        end
        RESET: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    state <= next_state;
    case (state)
        IDLE: begin
            if (a) begin
                q <= 4;
            end
        end
        COUNT: begin
            if (!a) begin
                if (q < 5) begin
                    q <= q + 1;
                end else begin
                    q <= 0;
                end
            end
        end
        RESET: begin
            q <= 4;
        end
    endcase
end

// Initialize q and state
initial begin
    q = 4;
    state = IDLE;
end

endmodule