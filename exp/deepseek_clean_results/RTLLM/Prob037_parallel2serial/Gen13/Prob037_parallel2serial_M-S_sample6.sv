module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;        // 2-bit binary counter
    reg [3:0] shift_reg;  // Shift register storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin  // Last cycle - load new data
                shift_reg <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB first
            end else begin
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
                dout <= shift_reg[2 - cnt];  // Output next bit
            end
        end
    end

endmodule