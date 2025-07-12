module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] counter = 0;
    reg [2:0] state = 0;  // [xor, and, or]
    reg [2:0] prev_state = 0;

    always @(posedge clk) begin
        case (counter)
            0: begin  // XOR operation
                state[0] <= x ^ prev_state[0];
                prev_state <= state;
                counter <= counter + 1;
            end
            1: begin  // AND operation
                state[1] <= x & ~prev_state[1];
                prev_state <= state;
                counter <= counter + 1;
            end
            2: begin  // OR operation
                state[2] <= x | ~prev_state[2];
                prev_state <= state;
                counter <= 0;
                z <= ~(|state);  // NOR output
            end
        endcase
    end

endmodule