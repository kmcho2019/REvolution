module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] shift_reg;
    reg [1:0] bit_cnt;

    assign dout = shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            bit_cnt   <= 2'b11;  // Initialized to 3 to trigger load on first valid cycle
            valid_out <= 1'b0;
        end else begin
            if (bit_cnt == 2'd3) begin
                // Load new data when all bits of previous data have been output
                shift_reg <= d;
                bit_cnt   <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                // Shift left by 1 bit to bring next bit to MSB
                shift_reg <= {shift_reg[2:0], 1'b0};
                bit_cnt   <= bit_cnt + 1'b1;
                // valid_out stays high for entire 4-bit output sequence
                valid_out <= 1'b1;
            end
        end
    end

endmodule