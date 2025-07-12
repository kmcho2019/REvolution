module serial2parallel (
    input          clk,
    input          rst_n,
    input          din_serial,
    input          din_valid,
    output [7:0]   dout_parallel,
    output reg     dout_valid
);

    reg [7:0] shift_reg;
    reg [3:0] cnt;

    // Shift register and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg  <= 8'b0;
            cnt        <= 4'd0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0; // default no valid each cycle

            if (din_valid) begin
                // Shift right and insert new bit at MSB
                shift_reg <= {din_serial, shift_reg[7:1]};
                
                if (cnt == 4'd7) begin
                    // Received 8 bits; pulse valid next cycle
                    dout_valid <= 1'b1;
                    cnt       <= 4'd0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    // Combinational output from shift register
    assign dout_parallel = shift_reg;

endmodule