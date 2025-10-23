module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] shift_reg;
    reg [1:0] cnt;

    assign dout = shift_reg[3];  // MSB is serial output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b00) begin
                // Load new data and output MSB immediately
                shift_reg <= d;
                valid_out <= 1'b1;
                cnt       <= cnt + 1'b1;
            end else begin
                // Shift left, output next bit, valid_out=0
                shift_reg <= {shift_reg[2:0], 1'b0};
                valid_out <= 1'b0;

                if (cnt == 2'b11)
                    cnt <= 2'b00;  // Reset counter after 4 bits
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

endmodule