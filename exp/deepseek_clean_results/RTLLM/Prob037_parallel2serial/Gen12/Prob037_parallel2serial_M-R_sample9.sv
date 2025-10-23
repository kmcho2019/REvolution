module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output wire dout
);

    reg [1:0] cnt;  // 2-bit counter (0-3)
    reg [3:0] data_reg;

    // Bit selection using counter as index
    assign dout = data_reg[3-cnt];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                cnt <= 2'b0;
                data_reg <= d;  // Load new parallel data
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    // Valid signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
        end else begin
            valid_out <= (cnt == 2'b11);
        end
    end

endmodule