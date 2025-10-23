module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and output MSB
                data_reg <= d;
                dout <= d[3];
                valid_out <= 1'b1;
                cnt <= 2'b00;
            end else begin
                // Output next bit
                dout <= data_reg[3-cnt];
                valid_out <= 1'b0;
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule