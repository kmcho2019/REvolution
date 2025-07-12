module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] data;                  // Internal data register
reg [1:0] cnt;                   // Internal counter
reg         valid;               // Internal valid signal
reg         clk_enable;          // Clock enable signal for clock gating

assign valid_out = (cnt == 0) ? 1 : 0;  // Assign valid signal based on counter value
assign dout = data[3];           // Assign most significant bit of data to output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers and signals
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
        clk_enable <= 1'b0;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, update data register and reset counter
            clk_enable <= 1'b1;
            data <= d;
            cnt <= 2'b00;
        end else if (cnt < 3) begin
            // Otherwise, increment counter and shift data register
            clk_enable <= 1'b1;
            cnt <= cnt + 1;
            data <= {data[2:0], data[3]};
        end else begin
            // Disable clock when counter is not being updated
            clk_enable <= 1'b0;
        end
    end
end

// Clock gating
always @ (posedge clk) begin
    if (clk_enable) begin
        // Update counter and data register only when clock is enabled
        if (cnt == 3) begin
            data <= d;
            cnt <= 2'b00;
        end else if (cnt < 3) begin
            cnt <= cnt + 1;
            data <= {data[2:0], data[3]};
        end
    end
end

endmodule