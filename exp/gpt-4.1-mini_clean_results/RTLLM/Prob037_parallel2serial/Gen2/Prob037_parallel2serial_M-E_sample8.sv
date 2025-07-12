module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [1:0] cnt;
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'd0;
            shift_reg <= 4'd0;
            dout      <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new parallel data at the end of 4-bit serialization
                shift_reg <= d;
                dout      <= d[3];        // Output MSB of new data
                cnt       <= 2'd0;
                valid_out <= 1'b1;        // Valid high on first output bit
            end else begin
                // Shift left by 1 bit to output next MSB
                shift_reg <= {shift_reg[2:0], 1'b0};
                dout      <= shift_reg[2];  // Next bit (shift_reg[3] was just output)
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule