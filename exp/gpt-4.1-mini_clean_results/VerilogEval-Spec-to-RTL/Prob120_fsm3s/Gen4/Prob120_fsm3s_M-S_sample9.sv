module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // Next state and output logic combined
    always @(*) begin
        case (state)
            A: begin
                next_state = (in == 1'b0) ? A : B;
                out = 1'b0;
            end
            B: begin
                next_state = (in == 1'b0) ? C : B;
                out = 1'b0;
            end
            C: begin
                next_state = (in == 1'b0) ? A : D;
                out = 1'b0;
            end
            D: begin
                next_state = (in == 1'b0) ? C : B;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule