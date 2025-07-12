module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // FSM states: IDLE (2'b00), BYTE1 (2'b01), BYTE2 (2'b10), BYTE3 (2'b11)
reg done_reg; // register to hold the done signal

// Initialize the FSM state and done register
initial begin
    state = 2'b00;
    done_reg = 1'b0;
end

// Define the FSM transitions and output logic
always @(posedge clk) begin
    if (reset) begin // reset the FSM state and done register
        state <= 2'b00;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3]) begin // check if the current byte has in[3]=1
                    state <= 2'b01; // transition to BYTE1 state
                end else begin
                    state <= 2'b00; // stay in IDLE state
                end
            end
            2'b01: begin // BYTE1 state
                state <= 2'b10; // transition to BYTE2 state
            end
            2'b10: begin // BYTE2 state
                state <= 2'b11; // transition to BYTE3 state
            end
            2'b11: begin // BYTE3 state
                done_reg <= 1'b1; // signal done
                state <= 2'b00; // transition back to IDLE state
            end
            default: state <= 2'b00; // default to IDLE state
        endcase
    end
end

// Drive the done output
assign done = (state == 2'b11) ? 1'b1 : done_reg;

// Reset the done register after one cycle
always @(posedge clk) begin
    if (reset || state != 2'b11) begin
        done_reg <= 1'b0;
    end
end

endmodule