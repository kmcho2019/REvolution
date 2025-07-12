module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Bit Detector module
reg start_bit_detected;
always @(posedge clk) begin
    if (reset) begin
        start_bit_detected <= 1'b0;
    end else if (~in) begin // Start bit detected
        start_bit_detected <= 1'b1;
    end else begin
        start_bit_detected <= 1'b0;
    end
end

// Byte Constructor module
reg [9:0] byte_register; // 10-bit register to store incoming byte
reg [3:0] bit_counter;
always @(posedge clk) begin
    if (reset) begin
        byte_register <= 10'b0;
        bit_counter <= 4'b0;
    end else if (start_bit_detected) begin
        byte_register <= {byte_register[8:0], in}; // Shift in new bit
        bit_counter <= bit_counter + 1;
    end
end

// Protocol Validator module
reg protocol_valid;
always @(posedge clk) begin
    if (reset) begin
        protocol_valid <= 1'b0;
    end else if (bit_counter == 10) begin // 10 bits received
        if (byte_register[9] && ~byte_register[0]) begin // Stop bit correct and start bit detected
            protocol_valid <= 1'b1;
        end else begin
            protocol_valid <= 1'b0;
        end
    end
end

// Byte Receiver module
reg state;
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0;
        done <= 1'b0;
    end else if (start_bit_detected) begin
        state <= 1'b1; // Transition to receiving state
    end else if (state && protocol_valid) begin
        done <= 1'b1; // Set done signal high
        state <= 1'b0; // Transition to idle state
    end else if (state && ~protocol_valid) begin
        state <= 1'b0; // Transition to idle state if protocol invalid
    end
end

endmodule