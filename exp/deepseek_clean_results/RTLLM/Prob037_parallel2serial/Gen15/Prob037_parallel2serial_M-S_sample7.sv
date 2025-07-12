module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                shift_reg <= d;      // Load new parallel data
                cnt <= 2'b0;         // Reset counter
                valid_out <= 1'b1;   // First bit is valid
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                cnt <= cnt + 1'b1;    // Increment counter
                valid_out <= 1'b0;    // Not first bit
            end
            dout <= shift_reg[3];    // Always output MSB
        end
    end

endmodule