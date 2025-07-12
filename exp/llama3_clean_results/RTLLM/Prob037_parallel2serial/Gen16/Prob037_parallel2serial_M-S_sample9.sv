module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] data;                   // Data register to store input data
reg [1:0] cnt;                   // Counter to keep track of the bits

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset data and counter
        data <= 4'b0000;
        cnt <= 2'b00;
    end else begin
        // If counter has reached 3, reset counter and update data
        if (cnt == 3) begin
            cnt <= 2'b00;
            data <= d;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
        end
    end
end

assign valid_out = (cnt == 0) ? 1 : 0;  
assign dout = data[3 - cnt];          

endmodule