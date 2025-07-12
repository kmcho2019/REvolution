module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit counter (0-3)
    reg [3:0] data_reg;     // Data register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            cnt <= cnt + 1'b1;  // Auto-wrap at 4 (11 + 1 = 00)
            if (cnt == 2'b0)    // Load new data when counter wraps
                data_reg <= d;
        end
    end

    assign valid_out = (cnt == 2'b0);  // Valid when loading new data
    assign dout = data_reg[3 - cnt];   // MSB first output

endmodule