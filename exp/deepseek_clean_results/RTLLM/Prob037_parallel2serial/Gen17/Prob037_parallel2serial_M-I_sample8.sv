module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;
    reg [2:0] shift_reg;  // Only need to store 3 bits after first output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            shift_reg <= 3'b000;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin  // Last cycle - load new data
                cnt <= 2'b00;
                shift_reg <= d[2:0];  // Store remaining 3 bits
                dout <= d[3];        // Output MSB first
                valid_out <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                // Barrel shifter - select appropriate bit
                dout <= (cnt == 2'b00) ? shift_reg[2] :
                       (cnt == 2'b01) ? shift_reg[1] : shift_reg[0];
                valid_out <= (cnt == 2'b00);  // Valid only on first bit
            end
        end
    end

endmodule