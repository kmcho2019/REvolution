module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Output the MSB of data_reg
    assign dout = data_reg[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b0;
            data_reg  <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                cnt      <= 2'b0;
                data_reg <= d;      // Load new parallel data at end of serialization
                valid_out <= 1'b1;  // valid_out asserted only on MSB output cycle (cnt=0 next cycle)
            end else begin
                cnt      <= cnt + 1'b1;
                valid_out <= 1'b0;
                // Shift left by 1 bit to bring next bit to MSB
                data_reg <= {data_reg[2:0], 1'b0};
            end
        end
    end

endmodule