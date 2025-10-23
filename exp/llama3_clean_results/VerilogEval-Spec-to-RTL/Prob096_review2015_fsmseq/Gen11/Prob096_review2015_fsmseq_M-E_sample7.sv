module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// 4-bit shift register to detect the sequence
reg [3:0] shift_reg;

// Counter to count the number of clock cycles for which the sequence has been detected
reg [3:0] counter;

// Flag to indicate if the sequence '1101' has been found
reg seq_found;

always @(posedge clk) begin
    // Active high synchronous reset
    if (reset) begin
        // Reset shift register, counter, and sequence found flag
        shift_reg <= 4'b0000;
        counter <= 4'b0000;
        seq_found <= 0;
    end else begin
        // Shift register update logic
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if the sequence matches '1101'
        if (shift_reg == 4'b1101) begin
            // Set sequence found flag if match is found
            seq_found <= 1;
            // Reset counter
            counter <= 4'b0001;
        end else if (seq_found) begin
            // Increment counter if sequence has been found
            counter <= counter + 1;
        end
    end
end

// Drive start_shifting directly from seq_found flag and counter value
assign start_shifting = (seq_found && counter > 4'b0000);

endmodule