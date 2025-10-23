module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] state;          // 2-bit state (0-3)
    reg [3:0] data_reg;       // Data register
    wire load_new_data = (state == 2'b11);  // Load signal

    // State transition (increment and wrap around)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b0;
            data_reg <= 4'b0;
        end else begin
            state <= state + 1'b1;  // Auto-wrap at 4 (11 + 1 = 00)
            if (load_new_data)
                data_reg <= d;      // Load new data on wrap
        end
    end

    // Output assignments
    assign valid_out = (state == 2'b00);  // Valid on first bit
    assign dout = data_reg[3 - state];    // MSB first (state 0: bit3, state1: bit2, etc.)

endmodule