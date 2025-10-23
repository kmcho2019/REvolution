module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    // Serial output is the MSB of shift_reg
    assign dout = shift_reg[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd0) begin
                // Load new data at start of 4-bit serialization
                shift_reg <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else begin
                // Shift left by 1, output next bit
                shift_reg <= {shift_reg[2:0], 1'b0};
                valid_out <= 1'b0;
                if (cnt == 2'd3)
                    cnt <= 2'b0;   // Reset counter after LSB output
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule