module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the MSB of data register as serial output
    assign dout = data[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // At last bit, load new parallel input, reset counter, assert valid_out
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                // Otherwise, rotate data left by 1, increment counter, deassert valid_out
                data      <= {data[2:0], data[3]};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule