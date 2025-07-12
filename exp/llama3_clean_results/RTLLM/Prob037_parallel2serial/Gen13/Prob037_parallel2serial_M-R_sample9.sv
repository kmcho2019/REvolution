module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data;                  // Internal data register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        data <= 4'b0000;
    end else begin
        case (cnt)
            2'b00: begin
                data <= d;
                valid_out <= 1'b1;
                dout <= data[3];
                cnt <= cnt + 1'b1;
            end
            2'b01: begin
                valid_out <= 1'b0;
                dout <= data[2];
                cnt <= cnt + 1'b1;
            end
            2'b10: begin
                dout <= data[1];
                cnt <= cnt + 1'b1;
            end
            2'b11: begin
                dout <= data[0];
                cnt <= 2'b00;
            end
        endcase
    end
end

endmodule