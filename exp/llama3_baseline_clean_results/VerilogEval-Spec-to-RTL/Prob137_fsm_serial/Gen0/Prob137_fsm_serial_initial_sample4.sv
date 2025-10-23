module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 0: Idle, 1: Start, 2: Data, 3: Stop, 4: Done
reg [2:0] data_count;
reg [7:0] data;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to idle state
        data_count <= 0;
    end
    else begin
        case (state)
            0: begin // Idle state
                if (!in) begin
                    state <= 1; // Transition to start state
                end
            end
            1: begin // Start state
                state <= 2; // Transition to data state
                data_count <= 0;
                data <= 0;
            end
            2: begin // Data state
                data[data_count] <= in; // Shift in the data bit
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    state <= 3; // Transition to stop state
                end
            end
            3: begin // Stop state
                if (in) begin
                    state <= 4; // Transition to done state
                end
                else begin
                    state <= 0; // Transition back to idle state if stop bit is not 1
                end
            end
            4: begin // Done state
                done <= 1;
                state <= 0; // Transition back to idle state
            end
            default: state <= 0;
        endcase
    end
end

assign done = (state == 4);

endmodule