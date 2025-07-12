module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to collect incoming data bits
reg [2:0] state; // 3-bit state register (IDLE, RECEIVE, WAIT_STOP)
reg start_bit_detected; // Flag to indicate start bit detection
reg stop_bit_verified; // Flag to indicate stop bit verification
reg [3:0] bit_count; // Counter to keep track of number of bits received

// Pipeline stage 1: Start bit detection
reg start_bit;

always @(posedge clk) begin
    if (reset) begin
        start_bit <= 1'b0;
    end else if (in == 1'b0) begin
        start_bit <= 1'b1;
    end else begin
        start_bit <= 1'b0;
    end
end

// Pipeline stage 2: Data bit collection
reg [7:0] data_shift_register;

always @(posedge clk) begin
    if (reset) begin
        data_shift_register <= 8'b0;
        bit_count <= 4'b0;
    end else if (start_bit_detected) begin
        data_shift_register <= {data_shift_register[6:0], in};
        bit_count <= bit_count + 1;
    end
end

// Pipeline stage 3: Stop bit verification
reg stop_bit;

always @(posedge clk) begin
    if (reset) begin
        stop_bit <= 1'b0;
    end else if (bit_count == 4'd8) begin
        stop_bit <= in;
    end
end

// Pipeline stage 4: Done signal generation and state transition
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset state (IDLE)
        done <= 1'b0; // Reset done signal
        start_bit_detected <= 1'b0; // Reset start bit detection flag
        stop_bit_verified <= 1'b0; // Reset stop bit verification flag
    end else begin
        case(state)
            3'b000: begin // IDLE state
                if (start_bit) begin
                    state <= 3'b001; // Transition to RECEIVE state
                    start_bit_detected <= 1'b1; // Set start bit detection flag
                end
            end
            3'b001: begin // RECEIVE state
                if (bit_count == 4'd8) begin
                    state <= 3'b010; // Transition to WAIT_STOP state
                end
            end
            3'b010: begin // WAIT_STOP state
                if (stop_bit == 1'b1) begin
                    done <= 1'b1; // Set done signal high
                    state <= 3'b000; // Transition to IDLE state
                    stop_bit_verified <= 1'b1; // Set stop bit verification flag
                end
            end
        endcase
        if (done) begin
            done <= 1'b0; // Reset done signal
        end
    end
end

endmodule