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

    reg [3:0] current_state;

    // State transition equations (direct implementation)
    wire [3:0] next_state;
    assign next_state[0] = (~in & (current_state[0] | current_state[2])) | reset;
    assign next_state[1] = (in & (current_state[0] | current_state[1] | current_state[3])) & ~reset;
    assign next_state[2] = (~in & current_state[1]) | (in & current_state[2]) & ~reset;
    assign next_state[3] = (in & current_state[2]) & ~reset;

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            out <= current_state[3];  // Output is registered version of state D
        end
    end

endmodule