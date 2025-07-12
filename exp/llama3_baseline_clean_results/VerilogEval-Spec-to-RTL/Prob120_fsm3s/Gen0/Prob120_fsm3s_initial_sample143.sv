module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state, next_state;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        case (state)
            A: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
                out <= 1'b0;
            end
            B: begin
                if (~in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
                out <= 1'b0;
            end
            C: begin
                if (~in) begin
                    state <= A;
                end else begin
                    state <= D;
                end
                out <= 1'b0;
            end
            D: begin
                if (~in) begin
                    state <= C;
                end else begin
                    state <= B;
                end
                out <= 1'b1;
            end
        endcase
    end
end

endmodule