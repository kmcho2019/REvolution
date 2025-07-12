module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;  // 2-bit counter (0-3)
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update counter
            cnt <= cnt + 1'b1;
            
            // Load new data when counter wraps
            if (cnt == 2'b11)
                data_reg <= d;
            
            // Direct bit selection (MSB first)
            dout <= data_reg[3 - cnt];
            
            // Valid when outputting first bit (MSB)
            valid_out <= (cnt == 2'b00);
        end
    end

endmodule