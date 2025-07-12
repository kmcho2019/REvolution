module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;
    reg [3:0] data_reg;

    // Next counter value (modulo 4)
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : (cnt + 1'b1);

    // Update counter and shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            if (cnt == 2'b11)  // Load new data at end of cycle
                data_reg <= d;
        end
    end

    // Output assignments
    assign valid_out = (cnt == 2'b00);  // Valid on first bit
    assign dout = data_reg[3 - cnt];    // Select current bit (MSB first)

endmodule