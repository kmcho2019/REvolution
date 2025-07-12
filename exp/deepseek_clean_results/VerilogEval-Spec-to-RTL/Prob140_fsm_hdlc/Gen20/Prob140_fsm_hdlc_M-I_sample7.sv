module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (s0 = reset state)
    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // s0 state
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (remain unchanged unless condition met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and output logic
            if (in) begin
                case (state)
                    8'b00000001: state <= 8'b00000010;  // s0 -> s1
                    8'b00000010: state <= 8'b00000100;  // s1 -> s2
                    8'b00000100: state <= 8'b00001000;  // s2 -> s3
                    8'b00001000: state <= 8'b00010000;  // s3 -> s4
                    8'b00010000: state <= 8'b00100000;  // s4 -> s5
                    8'b00100000: state <= 8'b01000000;  // s5 -> s6
                    8'b01000000: begin                  // s6 -> s7
                        state <= 8'b10000000;
                        err <= 1;  // Error on 7th 1
                    end
                    8'b10000000: err <= 1;  // Maintain error for >7 1s
                    default: state <= 8'b00000001;
                endcase
            end else begin
                case (state)
                    8'b00100000: disc <= 1;  // Discard after 5 1s
                    8'b01000000: flag <= 1;  // Flag after 6 1s
                    default: ;  // No action for other states
                endcase
                state <= 8'b00000001;  // Reset to s0 on 0 input
            end
        end
    end

endmodule