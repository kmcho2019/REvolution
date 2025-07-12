module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 4'd0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
            dout      <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new data at the start of the 4-bit serialization
                data_reg <= d;
            end else begin
                // Shift left by 1 bit, MSB goes out, LSB zero filled
                data_reg <= {data_reg[2:0], 1'b0};
            end

            dout      <= data_reg[3];         // Output MSB before shift
            valid_out <= (cnt <= 2'd3) ? 1'b1 : 1'b0;  // Valid for cnt=0..3

            // Increment counter modulo 4
            cnt <= cnt + 1;
        end
    end

endmodule