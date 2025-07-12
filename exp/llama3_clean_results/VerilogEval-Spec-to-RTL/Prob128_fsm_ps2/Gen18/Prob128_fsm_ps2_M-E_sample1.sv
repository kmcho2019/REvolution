module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] byte_count, next_byte_count;

always_comb begin
    next_byte_count = byte_count;
    done = 0;
    
    if (byte_count == 2'b11) begin // If we have received 3 bytes
        done = 1; // Assert done in the next cycle
    end
    
    if (in[3]) begin // Message start byte detected
        next_byte_count = 2'b01; // Reset counter to 1
    end
    else if (byte_count != 2'b00) begin // If we are in the middle of a message
        next_byte_count = byte_count + 1; // Increment counter
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
    end
    else begin
        byte_count <= next_byte_count;
    end
end

endmodule