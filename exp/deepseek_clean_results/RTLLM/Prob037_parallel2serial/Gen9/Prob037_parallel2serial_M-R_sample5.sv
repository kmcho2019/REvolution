module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // Binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    wire cnt_last = (cnt == 2'b11);  // Counter at last value

    // Next counter value
    wire [1:0] next_cnt = cnt_last ? 2'b00 : cnt + 1'b1;

    // Current output bit selection (MSB first)
    wire [1:0] bit_sel = cnt_last ? 2'b00 : (cnt + 1'b1);
    assign dout = data_reg[3-bit_sel];

    // Valid output when loading new data
    assign valid_out = cnt_last;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            if (cnt_last) begin
                data_reg <= d;  // Load new parallel data
            end
        end
    end

endmodule