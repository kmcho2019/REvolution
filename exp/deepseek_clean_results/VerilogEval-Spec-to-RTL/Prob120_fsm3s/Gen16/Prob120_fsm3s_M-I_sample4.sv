module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Binary encoding with Gray code ordering (only one bit changes per transition)
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    // State register
    reg [1:0] current_state;

    // Next state logic
    reg [1:0] next_state;
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic (Moore: output depends only on current state)
    assign out = (current_state == D);

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule