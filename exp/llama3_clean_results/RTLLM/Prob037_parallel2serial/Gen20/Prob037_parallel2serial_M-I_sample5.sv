module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [1:0] cnt;
reg [3:0] data_reg; // Register to store the input data
reg dout_reg; // Registered output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        data_reg <= 0;
        dout_reg <= 0;
    end else begin
        if (cnt == 3) begin // Last bit, update data register and reset counter
            data_reg <= d;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1; // Increment counter for the next bit
        end
        // Update output only when valid
        if (cnt == 0) begin
            dout_reg <= data_reg[3]; // Output MSB first
        end else begin
            dout_reg <= data_reg[3 - cnt + 1]; // Shift and output next bit
        end
    end
end

assign valid_out = (cnt == 0) ? 1 : 0; // Valid signal when counter is at start
assign dout = dout_reg; // Assign registered output

endmodule