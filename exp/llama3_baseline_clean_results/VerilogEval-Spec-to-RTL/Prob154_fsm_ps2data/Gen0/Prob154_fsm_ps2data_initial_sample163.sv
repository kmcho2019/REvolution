module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;

// Define the current state and the next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the shift register for the datapath
reg [23:0] shift_register;

// Define the done signal
reg done_reg;

always @(*) begin
    // Default values for the next state and done signal
    next_state = current_state;
    done_reg = 1'b0;

    // Determine the next state based on the current state and input
    case (current_state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = IDLE;
            done_reg = 1'b1;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk) begin
    // Reset the FSM and datapath if the reset signal is asserted
    if (reset == 1'b1) begin
        current_state <= IDLE;
        shift_register <= 24'b0;
        done_reg <= 1'b0;
    end else begin
        // Update the current state
        current_state <= next_state;

        // Update the shift register
        case (current_state)
            IDLE: begin
                // Do nothing
            end
            BYTE1: begin
                shift_register[23:16] <= in;
            end
            BYTE2: begin
                shift_register[15:8] <= in;
            end
            default: begin
                // Do nothing
            end
        endcase

        // Update the done signal
        done_reg <= done_reg;

        // If we are in the BYTE2 state, shift in the new byte and output the done signal
        if (current_state == BYTE2) begin
            shift_register[7:0] <= in;
        end
    end
end

// Output the out_bytes and done signals
assign out_bytes = shift_register;
assign done = done_reg;

endmodule