module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // One-hot state encoding
    parameter [3:0] A = 4'b0001,
                    B = 4'b0010,
                    C = 4'b0100,
                    D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            current_state[A]: next_state = in ? B : A;
            current_state[B]: next_state = in ? B : C;
            current_state[C]: next_state = in ? D : A;
            current_state[D]: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output register (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            out <= (next_state == D); // Registered output
        end
    end

endmodule