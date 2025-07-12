module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    LOAD,
    SHIFT,
    OUTPUT
} state, next_state;

// Internal registers
reg [3:0] data_reg;               // Register to hold the parallel input data

// FSM logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the FSM state and internal registers
        state <= IDLE;
        data_reg <= 4'b0000;
    end else begin
        // Update the FSM state and internal registers based on the current state
        case (state)
            IDLE: begin
                // Load the parallel input data into the data register
                data_reg <= d;
                state <= LOAD;
            end
            LOAD: begin
                // Shift the data in the data register one bit to the right
                data_reg <= {data_reg[2:0], 1'b0};
                state <= SHIFT;
            end
            SHIFT: begin
                // Output the most significant bit of the data register as the serial output
                state <= OUTPUT;
            end
            OUTPUT: begin
                // Return to the IDLE state
                state <= IDLE;
            end
        endcase
    end
end

// Output logic
always @ (*) begin
    case (state)
        IDLE: begin
            // Set the valid signal to 0 and the serial output to 0
            valid_out = 0;
            dout = 1'b0;
        end
        LOAD: begin
            // Set the valid signal to 1 and the serial output to the most significant bit of the data register
            valid_out = 1;
            dout = data_reg[3];
        end
        SHIFT: begin
            // Set the valid signal to 1 and the serial output to the most significant bit of the data register
            valid_out = 1;
            dout = data_reg[3];
        end
        OUTPUT: begin
            // Set the valid signal to 1 and the serial output to the most significant bit of the data register
            valid_out = 1;
            dout = data_reg[3];
        end
    endcase
end

endmodule