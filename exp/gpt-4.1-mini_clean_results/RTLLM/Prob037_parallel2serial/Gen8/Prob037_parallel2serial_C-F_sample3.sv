module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Output the bit indexed by cnt from MSB to LSB (3 down to 0)
    assign dout = data[3 - cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new parallel data and assert valid_out for first bit
                data      <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else begin
                // Clear valid_out after first bit and increment cnt
                valid_out <= 1'b0;
                if (cnt == 2'd3)
                    cnt <= 2'b0;
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule