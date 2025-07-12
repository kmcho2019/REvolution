module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                data      <= d;           // Load new parallel data
                cnt       <= 2'b0;       // Reset counter
                valid_out <= 1'b1;       // Indicate valid MSB output
            end else begin
                // Shift data left by 1, MSB wraps around to LSB
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;       // Only valid when cnt==3
            end
            dout <= data[3];              // Output MSB of data register
        end
    end

endmodule