module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] bit_counter;
    reg [7:0] data_reg;

    // Combinational control signals
    wire counter_max = (bit_counter == 3'd7);
    wire counter_clear = counter_max & din_valid;
    wire counter_enable = din_valid;
    wire [2:0] next_counter = counter_clear ? 3'b0 : (bit_counter + 1'b1);

    // Data path control
    wire load_output = counter_max & din_valid;
    wire shift_enable = din_valid & ~load_output;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 3'b0;
            data_reg <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Update counter
            bit_counter <= counter_enable ? next_counter : bit_counter;

            // Shift register operation
            if (shift_enable) begin
                data_reg <= {data_reg[6:0], din_serial};
            end

            // Parallel load and output
            if (load_output) begin
                dout_parallel <= {data_reg[6:0], din_serial};
                dout_valid <= 1'b1;
            end
            else begin
                dout_valid <= 1'b0;
            end
        end
    end

endmodule