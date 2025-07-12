module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;  // Registered parallel data to output serially
    reg [1:0] cnt;   // 2-bit counter for bit indexing

    // Output bit selected from registered data starting from MSB to LSB
    assign dout = data[3 - cnt];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            valid_out <= 1'b0;
            data      <= 4'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Finished outputting last bit, load new parallel data
                data      <= d;
                cnt       <= 2'b0;
                valid_out <= 1'b1;  // valid_out asserted when starting MSB output
            end else begin
                // Continue outputting bits from registered data
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule