module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter (0-3)
    reg [3:0] shift_reg; // Shift register for serial output

    // Counter and shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                shift_reg <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
            end else begin
                // Shift and increment counter
                shift_reg <= {shift_reg[2:0], 1'b0}; // Left shift
                cnt <= cnt + 1'b1;
                valid_out <= 1'b0;
            end
        end
    end

    // Serial output is always MSB of shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout <= 1'b0;
        end else begin
            dout <= shift_reg[3];
        end
    end

endmodule