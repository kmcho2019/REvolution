module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter

assign valid_out = (cnt == 0);   // Assign valid signal based on counter value
assign dout = d[3 - cnt];        // Assign bit from input data based on counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
    end else begin
        cnt <= cnt == 2'b11 ? 2'b00 : cnt + 1'b1;
    end
end

endmodule