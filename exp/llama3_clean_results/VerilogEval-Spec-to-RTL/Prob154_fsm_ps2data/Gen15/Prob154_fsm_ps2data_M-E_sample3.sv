module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define the states for the hybrid FSM
reg [2:0] state; // One-hot encoding scheme
wire [2:0] next_state;

// Define the control logic for the hybrid FSM
always @(*) begin
    case (state)
        3'b001: begin // Idle state
            if (in[3] == 1'b1) begin
                next_state = 3'b010; // Transition to byte1 state
            end else begin
                next_state = 3'b001; // Stay in idle state
            end
        end
        3'b010: begin // Byte1 state
            next_state = 3'b100; // Transition to byte2 state
        end
        3'b100: begin // Byte2 state
            next_state = 3'b001; // Transition back to idle state
        end
        default: begin
            next_state = 3'b001; // Reset to idle state
        end
    endcase
end

// Define the pipeline stages
reg [7:0] byte1, byte2;
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // Idle state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 3'b010; // Transition to byte1 state
                end else begin
                    state <= 3'b001; // Stay in idle state
                end
                done <= 1'b0;
            end
            3'b010: begin // Byte1 state
                byte2 <= in;
                state <= 3'b100; // Transition to byte2 state
                done <= 1'b0;
            end
            3'b100: begin // Byte2 state
                out_bytes[23:16] <= byte1;
                out_bytes[15:8] <= byte2;
                out_bytes[7:0] <= in;
                state <= 3'b001; // Transition back to idle state
                done <= 1'b1; // Signal done
            end
            default: begin
                state <= 3'b001; // Reset to idle state
                done <= 1'b0;
            end
        endcase
    end
end

endmodule