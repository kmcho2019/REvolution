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

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set all registers to initial state
        data <= 4'b0000;
        cnt <= 2'b00;
        valid <= 1'b0;
    end else begin
        // If the counter is 3, update data register, reset counter, and set valid signal
        if (cnt == 3) begin
            data <= d;
            cnt <= 2'b00;
            valid <= 1'b1;
        end else begin
            // Otherwise, increment counter, clear valid signal, and shift data register
            cnt <= cnt + 1;
            valid <= 1'b0;
            data <= {data[2:0], data[3]};
        end
    end
end

// Continuous assignment for output ports
assign dout = data[3];
assign valid_out = (cnt == 3) ? 1'b1 : (cnt != 0) ? 1'b1 : 1'b0;

endmodule