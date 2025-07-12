module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

parameter IDLE = 2'b00;
parameter FIRST_DATA_RECEIVED = 2'b01;

reg [1:0] state;
reg [7:0] data_first;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state            <= IDLE;
        data_first      <= 8'd0;
        valid_out_reg   <= 1'b0;
        data_out_reg   <= 16'd0;
    end
    else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_first  <= data_in;
                    state      <= FIRST_DATA_RECEIVED;
                end
                else begin
                    valid_out_reg  <= 1'b0;
                end
            end
            FIRST_DATA_RECEIVED: begin
                if (valid_in) begin
                    data_out_reg   <= {data_first, data_in};
                    valid_out_reg  <= 1'b1;
                    state          <= IDLE;
                end
                else begin
                    valid_out_reg  <= 1'b0;
                end
            end
            default: begin
                state            <= IDLE;
                valid_out_reg   <= 1'b0;
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule