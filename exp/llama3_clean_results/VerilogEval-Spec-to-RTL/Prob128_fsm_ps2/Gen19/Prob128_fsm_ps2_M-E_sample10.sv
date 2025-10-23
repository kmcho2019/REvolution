module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define a shift register to store the last three bytes
logic [23:0] shift_reg, next_shift_reg;

// Define a flag to track if we are currently receiving a message
logic receiving_message, next_receiving_message;

always_comb begin
    next_shift_reg = shift_reg;
    next_receiving_message = receiving_message;
    done = 1'b0; // Initialize done to 0
    
    // Shift the current byte into the register
    next_shift_reg = {in, shift_reg[23:8]};
    
    // Check if we are currently receiving a message
    if (receiving_message) begin
        // Check if this is the third byte of the message
        if (shift_reg[23:16] == 8'h00) begin
            // Signal done and reset the receiving message flag
            done = 1'b1;
            next_receiving_message = 1'b0;
        end
    end else begin
        // Check if the first byte of the current message has in[3]=1
        if (in[3]) begin
            // Set the receiving message flag
            next_receiving_message = 1'b1;
        end
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        shift_reg <= 24'h000000;
        receiving_message <= 1'b0;
    end
    else begin
        shift_reg <= next_shift_reg;
        receiving_message <= next_receiving_message;
    end
end

endmodule