module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0: Idle, 1: Start, 2: Data, 3: Stop
reg [3:0] count; // Count data bits
reg start_bit_detected;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to Idle state
        count <= 0;
        start_bit_detected <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (!in) begin // Start bit detected
                    state <= 1;
                    count <= 1;
                    start_bit_detected <= 1;
                end else begin
                    state <= 0;
                    start_bit_detected <= 0;
                end
            end
            1: begin // Start state (beginning of data)
                if (count == 8) begin
                    state <= 2; // Transition to Data state
                end else begin
                    count <= count + 1;
                end
            end
            2: begin // Data state
                if (count == 8) begin
                    state <= 3; // Transition to Stop state
                end else begin
                    count <= count + 1;
                end
            end
            3: begin // Stop state
                if (in) begin // Stop bit detected
                    state <= 0; // Transition back to Idle state
                    done <= 1; // Set done signal high
                end else begin // Stop bit not detected
                    state <= 0; // Transition back to Idle state
                    count <= 0;
                    start_bit_detected <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule