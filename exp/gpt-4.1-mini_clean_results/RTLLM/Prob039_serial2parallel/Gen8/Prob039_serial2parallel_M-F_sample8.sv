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
    wire [7:0] shift_in;

    assign shift_in = {din_serial, shift_reg[7:1]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count     <= 4'd0;
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default no valid output

            if (din_valid) begin
                shift_reg <= shift_in;
                bit_count <= bit_count + 4'd1;

                if (bit_count == 4'd7) begin
                    // After receiving 8 bits, output the parallel data and pulse valid
                    dout_parallel <= shift_in;
                    dout_valid    <= 1'b1;
                    bit_count     <= 4'd0;
                    // shift_reg will be overwritten on next din_valid cycles
                end
            end
        end
    end

endmodule