module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] next_state;

// Define the state transitions
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01; // Initialize to idle state (one-hot encoding)
    end else begin
        state <= next_state;
    end
end

// Define the next state logic
always @(*) begin
    case (state)
        2'b01: begin // Idle state
            if (in[3] == 1'b1) begin
                next_state = 2'b10; // Transition to byte1 state
            end else begin
                next_state = 2'b01; // Stay in idle state
            end
        end
        2'b10: begin // Byte1 state
            next_state = 2'b11; // Transition to byte2 state
        end
        2'b11: begin // Byte2 state
            next_state = 2'b01; // Transition back to idle state
        end
        default: begin
            next_state = 2'b01; // Reset to idle state
        end
    endcase
end

// Define the output logic
always @(posedge clk) begin
    if (reset) begin
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b01: begin // Idle state
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                end
                done <= 1'b0;
            end
            2'b10: begin // Byte1 state
                out_bytes[15:8] <= in;
                done <= 1'b0;
            end
            2'b11: begin // Byte2 state
                out_bytes[7:0] <= in;
                done <= 1'b1; // Signal done
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

endmodule