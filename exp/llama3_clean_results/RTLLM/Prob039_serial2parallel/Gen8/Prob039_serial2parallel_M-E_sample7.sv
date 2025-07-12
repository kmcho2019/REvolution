module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] state;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // idle state
                if (din_valid) begin
                    state <= 3'b001;
                    shift_reg <= {7'b0000000, din_serial};
                end
            end
            3'b001: begin // receiving data state
                if (din_valid) begin
                    shift_reg <= {shift_reg[6:0], din_serial};
                    if (&shift_reg[7:1]) begin // check if all bits except LSB are set
                        state <= 3'b010;
                    end
                end else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin // output data state
                dout_parallel <= shift_reg;
                dout_valid <= 1'b1;
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule