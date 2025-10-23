module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Gray-coded state encoding (only one bit changes between adjacent states)
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b11;
    parameter [1:0] D = 2'b10;

    reg [1:0] state;
    reg next_out;

    // Next state and output computation
    always @(*) begin
        case (state)
            A: begin
                state[1] = 1'b0;
                state[0] = in;
                next_out = 1'b0;
            end
            B: begin
                state[1] = ~in;
                state[0] = 1'b1;
                next_out = 1'b0;
            end
            C: begin
                state[1] = in;
                state[0] = ~in;
                next_out = 1'b0;
            end
            D: begin
                state[1] = 1'b1;
                state[0] = ~in;
                next_out = 1'b1;
            end
            default: begin
                state = A;
                next_out = 1'b0;
            end
        endcase
    end

    // State transition and output registration
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= state;
            out <= next_out;
        end
    end

endmodule