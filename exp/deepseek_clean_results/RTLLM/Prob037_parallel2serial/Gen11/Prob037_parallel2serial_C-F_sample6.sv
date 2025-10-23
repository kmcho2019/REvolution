module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] shift_reg;    // Shift register for parallel-to-serial conversion
    reg valid;              // Registered valid signal

    // Continuous assignments
    assign dout = shift_reg[3];       // Always output MSB
    assign valid_out = valid;         // Output registered valid signal

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            shift_reg <= 4'b0;
            valid <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                // Load new data and reset counter
                shift_reg <= d;
                cnt <= 2'b00;
                valid <= 1'b1;       // Assert valid on first bit
            end else begin
                // Shift left and increment counter
                shift_reg <= {shift_reg[2:0], 1'b0};
                cnt <= cnt + 1'b1;
                valid <= 1'b0;      // Deassert valid after first bit
            end
        end
    end

endmodule