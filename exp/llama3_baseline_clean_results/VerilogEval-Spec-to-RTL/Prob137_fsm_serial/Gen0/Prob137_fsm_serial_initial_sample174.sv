module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [7:0] byte; // Register to store the received byte
reg [2:0] state; // Current state of the FSM (3 states: IDLE, START, DATA/STOP)
reg [3:0] counter; // Counter for data bits
reg [7:0] data_bits; // Register to store the received data bits

// Assign default values
initial begin
    state = 0; // IDLE state
    counter = 0;
    byte = 0;
    data_bits = 0;
end

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state = 0; // Reset to IDLE state
        counter = 0;
        byte = 0;
        data_bits = 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state = 1; // Move to START state
                    counter = 0;
                end
            end
            1: begin // START state
                data_bits[0] = in; // Store the first data bit
                state = 2; // Move to DATA state
            end
            2: begin // DATA state
                if (counter < 7) begin
                    data_bits[counter + 1] = in; // Store the current data bit
                    counter = counter + 1;
                end else begin
                    data_bits[7] = in; // Store the last data bit
                    state = 3; // Move to STOP state
                end
            end
            3: begin // STOP state
                if (in) begin // Stop bit detected
                    byte = {data_bits[7], data_bits[6], data_bits[5], data_bits[4], data_bits[3], data_bits[2], data_bits[1], data_bits[0]}; // Store the received byte
                    state = 0; // Move back to IDLE state
                    counter = 0;
                end
            end
            default: state = 0; // Invalid state, reset to IDLE state
        endcase
    end
end

assign done = (state == 3 && in); // Assert 'done' when a byte is correctly received

endmodule