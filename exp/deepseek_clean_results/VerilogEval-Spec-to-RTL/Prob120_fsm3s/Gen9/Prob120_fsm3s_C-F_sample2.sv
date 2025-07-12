module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named state parameters for better readability
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Minimal output logic - only high in state D (11)
    assign out = (state == D);

endmodule