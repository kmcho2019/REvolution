module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Efficient state encoding (2 bits for 4 states)
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Optimized state transition logic (no default case needed)
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
        endcase
    end

    // Simple output logic (Moore machine)
    assign out = (current_state == D);

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule