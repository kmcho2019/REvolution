module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data_reg;              // Register to hold the input data

// Sequential logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers on reset
        cnt <= 2'b00;
        data_reg <= 4'b0000;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            // Load new data and reset counter
            data_reg <= d;
            cnt <= 2'b00;
            valid_out <= 1'b1;
        end else begin
            // Increment counter
            cnt <= cnt + 1'b1;
            valid_out <= 1'b0;
        end
    end
end

// Output logic
assign dout = data_reg[3 - cnt];

endmodule