module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data_reg;              // Register to store the parallel input

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  

// Assign serial output based on counter value
assign dout = data_reg[3 - cnt];

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data_reg <= 4'b0000;
    end else begin
        // Update counter and data register
        if (cnt == 3) begin
            // Load new parallel input and reset counter
            data_reg <= d;
            cnt <= 2'b00;
        end else begin
            // Increment counter
            cnt <= cnt + 1;
        end
    end
end

endmodule