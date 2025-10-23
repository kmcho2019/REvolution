module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // Gray-coded counter (00, 01, 11, 10)
    reg [1:0] gray_cnt;
    reg [3:0] shift_reg;

    // Gray code increment
    wire [1:0] next_gray = (gray_cnt == 2'b10) ? 2'b00 :
                          (gray_cnt == 2'b00) ? 2'b01 :
                          (gray_cnt == 2'b01) ? 2'b11 : 2'b10;

    // Shift register and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gray_cnt <= 2'b00;
            shift_reg <= 4'b0;
        end else begin
            gray_cnt <= next_gray;
            if (gray_cnt == 2'b10)  // Last state before wrap
                shift_reg <= d;      // Load new parallel data
            else
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
        end
    end

    // Output assignments
    assign valid_out = (gray_cnt == 2'b00);  // Valid on first bit
    assign dout = shift_reg[3];              // Always output MSB

endmodule