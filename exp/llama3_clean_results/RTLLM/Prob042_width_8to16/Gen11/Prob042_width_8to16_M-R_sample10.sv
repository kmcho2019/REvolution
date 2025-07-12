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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 2'b00; // IDLE state
        data_lock_reg <= 8'b0;
        data_out_reg <= 16'b0;
        valid_out_reg <= 1'b0;
    end else begin
        case (state_reg)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state_reg <= 2'b01; // DATA_LOCKED state
                    data_lock_reg <= data_in;
                end
            end
            2'b01: begin // DATA_LOCKED state
                if (valid_in) begin
                    state_reg <= 2'b10; // OUTPUT_GENERATED state
                    data_out_reg <= {data_lock_reg, data_in};
                    valid_out_reg <= 1'b1;
                end
            end
            2'b10: begin // OUTPUT_GENERATED state
                state_reg <= 2'b00; // IDLE state
                valid_out_reg <= 1'b0;
            end
            default: state_reg <= 2'b00; // IDLE state
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule