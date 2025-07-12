module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output       dout
);

    reg [3:0] shift_reg;
    reg [2:0] cnt; // Counts 0 to 4 (needs 3 bits)

    assign dout = shift_reg[3];  // MSB of shift_reg is the serial output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            cnt       <= 3'd4;  // Indicates ready state
            valid_out <= 1'b0;
        end else begin
            if (cnt == 3'd4) begin
                // Load new parallel data and output MSB next cycle
                shift_reg <= d;
                cnt       <= 3'd0;
                valid_out <= 1'b1;  // Valid output on MSB of new data
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left by 1
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;  // Valid only on MSB output cycle
            end
        end
    end

endmodule