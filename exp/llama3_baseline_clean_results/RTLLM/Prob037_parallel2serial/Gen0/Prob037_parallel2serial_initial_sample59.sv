module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data; // Register to hold the parallel input data
reg [1:0] cnt;  // Counter to track the output bits
reg valid;      // Internal valid signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers to their initial state
        cnt <= 0;
        data <= 0;
        valid <= 0;
    end else begin
        // If it's the last bit of the current data, update data and reset counter
        if (cnt == 3) begin
            data <= d;
            cnt <= 0;
            valid <= 1;
        end else begin
            // Otherwise, increment counter and shift data
            cnt <= cnt + 1;
            valid <= 0;
            // Shift data one bit to the left, with the most significant bit shifted to the least significant bit
            data <= {data[2:0], data[3]};
        end
    end
end

// Output logic
assign valid_out = (cnt == 0 && valid) ? 1 : 0;
assign dout = data[3];

endmodule