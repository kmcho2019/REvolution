module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] data;     // Data register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data <= 4'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                data <= d;          // Latch new data
                cnt <= 2'b0;        // Reset counter
            end else begin
                cnt <= cnt + 1'b1;  // Increment counter
            end
            dout <= data[3-cnt];    // Output current bit
        end
    end

    // valid_out is high only when counter is 0
    assign valid_out = (cnt == 2'b0);

endmodule