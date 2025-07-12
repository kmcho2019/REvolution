module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data register for parallel-to-serial conversion

    // Optimized state transition
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);

    // Continuous assignments
    assign dout = data_reg[3];              // Always output MSB
    assign valid_out = (cnt == 2'b00);      // Valid only on first bit

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            if (cnt == 2'b11) begin
                // Load new data at end of cycle
                data_reg <= d;
            end else begin
                // Shift left
                data_reg <= {data_reg[2:0], 1'b0};
            end
        end
    end

endmodule