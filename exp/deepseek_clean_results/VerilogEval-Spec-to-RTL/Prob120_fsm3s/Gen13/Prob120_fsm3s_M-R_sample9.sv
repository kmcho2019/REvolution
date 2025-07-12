module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding with parameters
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] current_state, next_state;

    // Next state logic using case statement
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic (Moore - depends only on current state)
    always @(*) begin
        out = (current_state == D);
    end

    // State register update
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule