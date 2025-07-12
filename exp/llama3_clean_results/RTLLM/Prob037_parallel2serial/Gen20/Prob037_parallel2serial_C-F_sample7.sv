module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits

// Always block for counter update
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter
        cnt <= 2'b00;
    end else begin
        // Update counter
        cnt <= (cnt == 2'd3) ? 2'b00 : cnt + 1;
    end
end

// Assign valid signal based on counter value
assign valid_out = (cnt == 2'b00) ? 1'b1 : 1'b0;

// Assign output based on counter value and input data
assign dout = d[3 - cnt];

endmodule