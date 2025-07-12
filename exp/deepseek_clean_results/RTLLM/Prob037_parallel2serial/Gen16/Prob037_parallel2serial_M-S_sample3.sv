module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit counter (0-3)
    reg [3:0] data_reg;     // Data shift register

    assign dout = data_reg[3];      // Always output MSB
    assign valid_out = (cnt == 0);  // Valid on first bit

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            data_reg <= 0;
        end else begin
            if (cnt == 3) begin
                cnt <= 0;
                data_reg <= d;      // Load new data
            end else begin
                cnt <= cnt + 1;
                data_reg <= {data_reg[2:0], 1'b0};  // Shift left
            end
        end
    end

endmodule