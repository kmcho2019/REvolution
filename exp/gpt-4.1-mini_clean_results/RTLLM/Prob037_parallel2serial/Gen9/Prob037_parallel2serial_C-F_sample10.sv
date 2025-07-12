module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;      // registered input data stable during serial output
    reg [1:0] cnt;       // 2-bit counter indexing bits 3 down to 0

    // Output bit from registered data, MSB first: data[3 - cnt]
    assign dout = data[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Completed serializing 4 bits, load new data and reset counter
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1; // valid on MSB output cycle (cnt=0)
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule