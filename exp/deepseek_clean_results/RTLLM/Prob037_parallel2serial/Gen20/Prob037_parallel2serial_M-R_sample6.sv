module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // 2-bit binary counter (0-3)
    reg [3:0] data_reg;     // Data storage register
    wire [1:0] next_cnt = (cnt == 2'b11) ? 2'b00 : cnt + 1'b1;

    // Circular buffer pointer arithmetic
    wire [1:0] bit_sel = 2'b11 - cnt;  // Selects bits in MSB to LSB order
    wire load_new = (cnt == 2'b11);

    // Output assignments
    assign dout = data_reg[bit_sel];
    assign valid_out = ~load_new;  // Valid when not loading new data

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 2'b00;
            data_reg <= 4'b0;
        end else begin
            cnt <= next_cnt;
            
            if (load_new) begin
                data_reg <= d;  // Load new parallel data
            end
        end
    end

endmodule