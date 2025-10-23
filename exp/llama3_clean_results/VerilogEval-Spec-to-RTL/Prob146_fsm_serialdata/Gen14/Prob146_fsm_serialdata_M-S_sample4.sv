module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] bit_counter;
reg [7:0] data;
reg idle;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        idle <= 1;
        data <= 8'b0;
        bit_counter <= 3'b000;
        done <= 0;
    end else begin
        if (idle) begin
            if (!in) begin
                // Start bit detected
                idle <= 0;
                bit_counter <= 3'b001;
                data <= 8'b0;
            end
        end else if (bit_counter < 3'd008) begin
            // Collecting data bits
            data <= {data[6:0], in};
            bit_counter <= bit_counter + 1;
        end else if (in) begin
            // Stop bit received
            idle <= 1;
            out_byte <= data;
            done <= 1;
        end else begin
            // Wait for stop bit
            done <= 0;
        end
    end
end

// Combinational logic to keep 'done' high for one cycle after a stop bit
always @(posedge clk) begin
    if (done) begin
        done <= 0;
    end
end

endmodule