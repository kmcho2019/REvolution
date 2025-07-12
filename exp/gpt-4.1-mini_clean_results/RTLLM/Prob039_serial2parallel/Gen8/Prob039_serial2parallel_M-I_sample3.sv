module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output reg [7:0]  dout_parallel,
    output reg        dout_valid
);

    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    // Compute next shift register value once to avoid redundant concatenation
    wire [7:0] next_shift = {din_serial, shift_reg[7:1]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count     <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output

            if (din_valid) begin
                shift_reg <= next_shift;
                bit_count <= bit_count + 4'd1;

                if (bit_count == 4'd7) begin
                    dout_parallel <= next_shift;
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0;
                    // shift_reg will continue to shift with next valid input
                end
            end
        end
    end

endmodule