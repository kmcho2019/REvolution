module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding (4 states)
    parameter [3:0] A = 4'b0001;
    parameter [3:0] B = 4'b0010;
    parameter [3:0] C = 4'b0100;
    parameter [3:0] D = 4'b1000;

    // State register
    reg [3:0] current_state, next_state;

    // State transition logic (simplified with one-hot)
    always @(*) begin
        next_state = 4'b0; // Default to catch undefined states
        case (1'b1) // Synthesis will optimize this
            current_state[A]: next_state = in ? B : A;
            current_state[B]: next_state = in ? B : C;
            current_state[C]: next_state = in ? D : A;
            current_state[D]: next_state = in ? B : C;
        endcase
    end

    // Output register (set when in state D)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            out <= current_state[D];
        end
    end

endmodule