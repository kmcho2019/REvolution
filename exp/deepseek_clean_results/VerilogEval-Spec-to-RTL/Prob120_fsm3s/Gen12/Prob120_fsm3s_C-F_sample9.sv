module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Optimized Gray code state encoding for minimal transitions
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b11;
    parameter D = 2'b10;

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Simple combinational output (only high in state D)
    assign out = (current_state == D);

endmodule