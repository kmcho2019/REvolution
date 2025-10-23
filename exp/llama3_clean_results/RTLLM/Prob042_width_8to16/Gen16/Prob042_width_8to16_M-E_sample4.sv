module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [1:0] state_reg;
reg [7:0] data_lock_reg;
reg [15:0] data_out_reg;
reg valid_out_reg;

parameter IDLE = 2'b00;
parameter DATA_LOCKED = 2'b01;
parameter OUTPUT_VALID = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= IDLE;
        data_lock_reg <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (valid_in) begin
                    data_lock_reg <= data_in;
                    state_reg <= DATA_LOCKED;
                end
            end
            DATA_LOCKED: begin
                if (valid_in) begin
                    data_out_reg <= {data_lock_reg, data_in};
                    valid_out_reg <= 1'b1;
                    state_reg <= OUTPUT_VALID;
                end
            end
            OUTPUT_VALID: begin
                valid_out_reg <= 1'b0;
                state_reg <= IDLE;
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule