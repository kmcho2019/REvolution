module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] data_reg;
    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data_reg <= 4'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data
                data_reg <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
                dout <= d[3];  // Output MSB immediately
            end else begin
                // Shift operation
                data_reg <= {data_reg[2:0], 1'b0};
                cnt <= cnt + 1;
                valid_out <= 1'b0;
                dout <= data_reg[2];  // Next bit is now in MSB position
            end
        end
    end

endmodule