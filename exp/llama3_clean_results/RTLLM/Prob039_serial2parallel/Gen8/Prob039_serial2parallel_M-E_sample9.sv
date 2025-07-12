module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [7:0] shift_reg;
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 8'b00000000;
        state <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE state
                if (din_valid) begin
                    shift_reg[0] <= din_serial;
                    state <= 3'b001;
                end
            end
            3'b001: begin // SHIFT state
                shift_reg <= {din_serial, shift_reg[7:1]};
                if (din_valid) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b010;
                end
            end
            3'b010: begin // OUTPUT state
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