module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    assign dout = shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'd0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load parallel data into shift register at start of serialization
                shift_reg <= d;
                valid_out <= 1'b1;  // Indicate valid output (MSB)
                cnt       <= 2'd1;  // Move to next bit position
            end else begin
                // Shift right to output next bit in MSB-first order
                shift_reg <= {1'b0, shift_reg[3:1]};
                valid_out <= 1'b0;  // Only valid on MSB output cycle
                if (cnt == 2'd3)
                    cnt <= 2'd0;   // Reset counter after last bit sent
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule