module TopModule(
    input               clk,
    input               reset,
    input       [7:0]   in,
    output reg [23:0]   out_bytes,
    output reg          done
);

reg [1:0] state; // State variable: 0 - idle, 1 - first byte received, 2 - second byte received
reg [1:0] nextState; // Next state variable
reg [23:0] message; // Register to accumulate the message
reg [7:0] byte1, byte2, byte3; // Registers for the three bytes of the message

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
        out_bytes <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (in[3] == 1) begin
                    nextState <= 1;
                    byte1 <= in;
                end else begin
                    nextState <= 0;
                end
            end
            1: begin // First byte received
                nextState <= 2;
                byte2 <= in;
            end
            2: begin // Second byte received
                nextState <= 3;
                byte3 <= in;
            end
            3: begin // Third byte received, signal done
                nextState <= 0;
                done <= 1;
                out_bytes <= {byte1, byte2, byte3};
            end
            default: begin
                nextState <= 0;
            end
        endcase

        state <= nextState;
    end

    if (state != 3) begin
        done <= 0; // Reset done after one clock cycle
    end
end

endmodule