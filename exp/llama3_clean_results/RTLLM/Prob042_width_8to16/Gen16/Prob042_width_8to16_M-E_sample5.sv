module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

parameter IDLE      = 2'd0;
parameter DATA_STORED = 2'd1;
parameter OUTPUT     = 2'd2;

reg [1:0] state, next_state;
reg [7:0] data_first, data_second;
reg [15:0] data_out_reg;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state          <= IDLE;
        data_first     <= 8'd0;
        data_second    <= 8'd0;
        data_out_reg   <= 16'd0;
        valid_out_reg  <= 1'b0;
    end
    else begin
        state          <= next_state;
        case (state)
            IDLE: begin
                if (valid_in) begin
                    data_first     <= data_in;
                    next_state     <= DATA_STORED;
                end
                else begin
                    next_state     <= IDLE;
                end
            end
            DATA_STORED: begin
                if (valid_in) begin
                    data_second    <= data_in;
                    data_out_reg   <= {data_first, data_in};
                    valid_out_reg  <= 1'b1;
                    next_state     <= OUTPUT;
                end
                else begin
                    next_state     <= DATA_STORED;
                end
            end
            OUTPUT: begin
                valid_out_reg  <= 1'b0;
                next_state     <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule