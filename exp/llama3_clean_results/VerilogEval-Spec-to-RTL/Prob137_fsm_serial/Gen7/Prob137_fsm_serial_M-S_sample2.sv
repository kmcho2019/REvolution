module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [7:0] data_register; // 8-bit register to store incoming data bits
reg [3:0] bit_count; // 4-bit counter to track number of bits received
reg receiving; // Flag to indicate receiving state

always @(posedge clk) begin
    if (reset) begin
        data_register <= 8'b0; // Reset data register
        bit_count <= 4'b0; // Reset counter
        receiving <= 1'b0; // Reset receiving flag
        done <= 1'b0; // Reset done signal
    end else begin
        if (~receiving) begin // IDLE state
            if (~in) begin // Start bit detected
                receiving <= 1'b1; // Set receiving flag
                data_register <= 8'b0; // Reset data register
                bit_count <= 4'b1; // Increment counter
            end
        end else begin // RECEIVE state
            if (bit_count < 4'b1001) begin // Check if 9 bits are received
                data_register <= {data_register[6:0], in}; // Shift in new bit
                bit_count <= bit_count + 1; // Increment counter
            end
            if (bit_count == 4'b1001) begin // 9 bits received
                if (in) begin // Stop bit correct
                    done <= 1'b1; // Set done signal high
                end
                receiving <= 1'b0; // Reset receiving flag
                bit_count <= 4'b0; // Reset counter
            end
        end
    end
end

always @(posedge clk) begin
    if (done) begin
        done <= 1'b0; // Reset done signal after one clock cycle
    end
end

endmodule