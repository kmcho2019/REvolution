module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg dout_valid_reg;
reg [2:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 3'b000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (din_valid) begin
                    state <= 3'b001;
                    dout_parallel_reg <= {din_serial, 7'b0000000};
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin // Data reception state
                if (din_valid) begin
                    dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
                    if (dout_parallel_reg[0] == din_serial) begin
                        state <= 3'b010;
                    end else begin
                        state <= 3'b001;
                    end
                end else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin // Output valid state
                dout_valid_reg <= 1'b1;
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule