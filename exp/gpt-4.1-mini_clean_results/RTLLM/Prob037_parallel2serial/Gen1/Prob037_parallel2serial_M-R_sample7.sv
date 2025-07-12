module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output          dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    // dout is always the MSB of the shift register
    assign dout = shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'd3;     // Force loading input on first clock cycle after reset
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                // Load new data into shift register and set valid_out
                shift_reg <= d;
                cnt       <= 2'd0;
                valid_out <= 1'b1;  // MSB output valid
            end else begin
                // Shift left by 1 bit (MSB to LSB direction), shifting in zero at LSB
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;  // Only MSB output cycle is valid_out=1
            end
        end
    end

endmodule