module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding using parameters
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Moore output)
    always @(*) begin
        out = (state == D) ? 1'b1 : 1'b0;
    end

endmodule