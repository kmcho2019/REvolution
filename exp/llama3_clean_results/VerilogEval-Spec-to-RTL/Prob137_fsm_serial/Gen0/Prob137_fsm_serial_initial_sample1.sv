module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state;  // States: Idle (0), Start (1), Data (2), Stop (3), WaitStop (4)
reg [2:0] dataCnt;  // Counter for data bits

always @(posedge clk) begin
    if (reset) begin  // Synchronous reset
        state <= 0;  // Reset state to idle
        dataCnt <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin  // Idle state
                if (!in) begin  // Start bit detected (0)
                    state <= 1;  // Transition to start state
                end
            end
            1: begin  // Start state
                state <= 2;  // Transition to data state
                dataCnt <= 1;  // Initialize data bit counter
            end
            2: begin  // Data state
                if (dataCnt == 8) begin  // 8 data bits received
                    state <= 3;  // Transition to stop state
                end else begin
                    dataCnt <= dataCnt + 1;  // Increment data bit counter
                end
            end
            3: begin  // Stop state
                if (in) begin  // Stop bit correct (1)
                    state <= 0;  // Transition back to idle state
                    done <= 1;  // Signal byte received
                end else begin  // Stop bit incorrect
                    state <= 4;  // Transition to wait for stop state
                end
            end
            4: begin  // Wait for stop state
                if (in) begin  // Stop bit detected (1)
                    state <= 0;  // Transition back to idle state
                end
            end
        endcase
    end
end

always @(negedge clk) begin
    done <= 0;  // Deassert done at the end of the clock cycle
end

endmodule