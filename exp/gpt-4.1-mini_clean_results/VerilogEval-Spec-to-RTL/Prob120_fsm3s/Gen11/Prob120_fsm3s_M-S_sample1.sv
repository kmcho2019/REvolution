module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        case(state)
            A: begin next_state = in ? B : A; out = 1'b0; end
            B: begin next_state = in ? B : C; out = 1'b0; end
            C: begin next_state = in ? D : A; out = 1'b0; end
            D: begin next_state = in ? B : C; out = 1'b1; end
        endcase
    end

    // Sequential logic for state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule