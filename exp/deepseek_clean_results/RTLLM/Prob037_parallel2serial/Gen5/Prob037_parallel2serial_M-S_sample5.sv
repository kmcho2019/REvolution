module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11)
                data_reg <= d;
            cnt <= cnt + 1'b1;
        end
    end

    assign valid_out = (cnt == 2'b00);
    assign dout = data_reg[3 - cnt];  // MSB first

endmodule