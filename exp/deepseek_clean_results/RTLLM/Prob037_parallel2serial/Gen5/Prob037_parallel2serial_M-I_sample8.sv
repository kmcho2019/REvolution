module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;          // 2-bit gray code counter (0-3)
    reg [3:0] shift_reg;    // Combined data storage and shift register

    // Gray code sequence: 00, 01, 11, 10
    wire [1:0] next_cnt_gray;
    assign next_cnt_gray = (cnt == 2'b10) ? 2'b00 : 
                          (cnt == 2'b00) ? 2'b01 :
                          (cnt == 2'b01) ? 2'b11 : 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            shift_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            // Update counter
            cnt <= next_cnt_gray;
            
            // Handle data loading and shifting
            if (cnt == 2'b10) begin  // Gray code for 3 (last count)
                shift_reg <= d;      // Load new data
                dout <= d[3];        // Output MSB
            end else begin
                shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                dout <= shift_reg[2];                 // Next bit
            end
            
            // Synchronized valid output
            valid_out <= (next_cnt_gray == 2'b00);
        end
    end

endmodule