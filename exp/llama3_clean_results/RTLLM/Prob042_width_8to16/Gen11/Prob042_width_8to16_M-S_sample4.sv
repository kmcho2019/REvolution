module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg state_reg;
reg [7:0] data_lock_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 1'b0; // IDLE state
        data_lock_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        case (state_reg)
            1'b0: begin // IDLE state
                if (valid_in) begin
                    state_reg <= 1'b1; // DATA_LOCKED state
                    data_lock_reg <= data_in;
                    valid_out <= 1'b0;
                    data_out <= 16'b0;
                end else begin
                    valid_out <= 1'b0;
                    data_out <= 16'b0;
                end
            end
            1'b1: begin // DATA_LOCKED state
                if (valid_in) begin
                    state_reg <= 1'b0; // IDLE state
                    valid_out <= 1'b1;
                    data_out <= {data_lock_reg, data_in};
                end else begin
                    valid_out <= 1'b0;
                    data_out <= 16'b0;
                end
            end
            default: begin
                state_reg <= 1'b0;
                data_lock_reg <= 8'b0;
                valid_out <= 1'b0;
                data_out <= 16'b0;
            end
        endcase
    end
end

endmodule