module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_register;
reg [2:0] bit_counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_register <= 8'b00000000;
        bit_counter <= 3'b000;
        dout_valid <= 1'b0;
    end else begin
        if (din_valid) begin
            shift_register <= {shift_register[6:0], din_serial};
            bit_counter <= bit_counter + 1'b1;
            if (bit_counter == 3'b111) begin
                dout_parallel <= shift_register;
                dout_valid <= 1'b1;
                bit_counter <= 3'b000;
            end
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule