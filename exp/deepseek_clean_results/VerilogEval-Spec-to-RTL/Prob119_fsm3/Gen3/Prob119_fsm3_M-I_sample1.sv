module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Gray code state encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end
        else begin
            state <= next_state;
            out <= (next_state == D);
        end
    end

endmodule