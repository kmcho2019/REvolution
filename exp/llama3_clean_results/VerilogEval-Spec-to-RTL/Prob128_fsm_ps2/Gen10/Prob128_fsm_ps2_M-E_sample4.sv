module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Shift register to store the current byte
logic [7:0] byte_shift_register;
always_ff @(posedge clk) begin
    if (reset) begin
        byte_shift_register <= 8'b0;
    end else begin
        byte_shift_register <= in;
    end
end

// Byte counter to track the number of bytes since the last message start
logic [1:0] byte_counter;
always_ff @(posedge clk) begin
    if (reset) begin
        byte_counter <= 2'b0;
    end else if (byte_shift_register[3] && (byte_counter == 2'b0)) begin
        // Reset counter when a new message start is detected
        byte_counter <= 2'b1;
    end else if (byte_counter < 2'b3) begin
        // Increment counter for each subsequent byte
        byte_counter <= byte_counter + 1;
    end else begin
        byte_counter <= 2'b0;
    end
end

// Done signal generation
always_ff @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (byte_counter == 2'b3) begin
        // Assert done signal when a complete message is received
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule