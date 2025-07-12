module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [1:0] cnt;       // Counts from 0 to 3 for bits output
    reg [3:0] data_reg;  // Holds the parallel data to serialize

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            data_reg  <= 4'd0;
            dout      <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data at end of previous serialization
                data_reg  <= d;
                cnt       <= 2'd0;
                dout      <= d[3];       // MSB first
                valid_out <= 1'b1;       // Valid only on first bit output
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
                // Output the bit corresponding to (3 - cnt) so MSB -> LSB
                dout <= data_reg[3 - (cnt + 1)];
            end
        end
    end

endmodule