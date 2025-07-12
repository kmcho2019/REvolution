module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (shift_reg == 4'b0) begin
                // Load new data
                shift_reg <= d;
                valid_out <= 1'b1;
                dout <= d[3];
            end else begin
                // Shift out next bit
                shift_reg <= {shift_reg[2:0], 1'b0};
                valid_out <= 1'b0;
                dout <= shift_reg[2];
            end
        end
    end

endmodule