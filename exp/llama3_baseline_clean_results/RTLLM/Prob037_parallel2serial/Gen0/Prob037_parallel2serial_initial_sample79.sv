module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] cnt;
reg valid;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        data <= 4'd0;
        cnt <= 2'd0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'd3) begin
            // Last bit output, prepare for next parallel input
            data <= d;
            cnt <= 2'd0;
            valid <= 1'b1;
        end else begin
            // Output next bit of current parallel input
            cnt <= cnt + 1'b1;
            valid <= 1'b0;
            // Shift data left, moving next bit to MSB for output
            data <= {data[2:0], 1'b0};
        end
    end
end

assign dout = data[3]; // MSB of data is always output
assign valid_out = (cnt == 2'd0) && valid; // Valid after first bit output

endmodule