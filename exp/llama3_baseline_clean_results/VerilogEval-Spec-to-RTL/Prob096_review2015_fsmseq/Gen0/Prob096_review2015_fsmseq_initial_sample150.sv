module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
enum logic [2:0] {
    Idle,
    S1,
    S2,
    S3,
    Found
} state, next_state;

always @(*) begin
    case (state)
        Idle: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = Idle;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = Found;
            end else begin
                next_state = Idle;
            end
        end
        Found: begin
            next_state = Found;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        case (state)
            Found: begin
                start_shifting <= 1;
            end
            default: begin
                start_shifting <= 0;
            end
        endcase
    end
end

endmodule