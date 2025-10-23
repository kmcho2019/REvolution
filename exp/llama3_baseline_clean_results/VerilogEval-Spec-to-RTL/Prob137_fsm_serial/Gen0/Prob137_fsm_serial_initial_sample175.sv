module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // FSM states: IDLE (3'b000), DATA (3'b001), STOP (3'b010), DONE (3'b011)
reg [2:0] data_count; // Counter for data bits
reg [7:0] data_byte; // Collected data bits

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 3'b000; // IDLE
        data_count <= 3'b000;
        data_byte <= 8'b00000000;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 3'b001; // Transition to DATA
                    data_count <= 3'b000;
                    data_byte <= 8'b00000000;
                end
            end
            3'b001: begin // DATA
                data_byte[7 - data_count] <= in; // Collect data bit
                data_count <= data_count + 1'b1;
                if (data_count == 3'b1000) begin // 8 data bits collected
                    state <= 3'b010; // Transition to STOP
                end
            end
            3'b010: begin // STOP
                if (in) begin // Stop bit verified
                    state <= 3'b011; // Transition to DONE
                    done <= 1'b1;
                end else begin // Stop bit not verified
                    state <= 3'b000; // Transition back to IDLE
                end
            end
            3'b011: begin // DONE
                state <= 3'b000; // Transition back to IDLE
                done <= 1'b0;
            end
            default: state <= 3'b000; // IDLE
        endcase
    end
end

endmodule