module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                  // Internal state variable
reg [3:0] data_reg;               // Data register to store input data

// Sequential logic for state machine and data register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and data register on reset
        state <= 2'b00;
        data_reg <= 4'b0000;
    end else if (state == 2'b11) begin
        // If state has reached 3, reset state and update data register
        state <= 2'b00;
        data_reg <= d;
    end else begin
        // Otherwise, increment state
        state <= state + 1'b1;
    end
end

// Assign valid signal and output based on state
assign valid_out = (state == 2'b00);
assign dout = data_reg[3 - state];

endmodule