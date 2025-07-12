module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state;
reg [7:0] data_high;
reg [7:0] data_low;
reg         valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'd0; // IDLE state
        data_high <= 8'd0;
        data_low <= 8'd0;
        valid_out_reg <= 1'b0;
    end
    else begin
        case (state)
            2'd0: begin // IDLE state
                if (valid_in) begin
                    data_high <= data_in;
                    state <= 2'd1; // CONVERT state
                end
            end
            2'd1: begin // CONVERT state
                if (valid_in) begin
                    data_low <= data_in;
                    state <= 2'd2; // OUTPUT state
                end
            end
            2'd2: begin // OUTPUT state
                state <= 2'd0; // IDLE state
                valid_out_reg <= 1'b1;
            end
            default: begin
                state <= 2'd0; // IDLE state
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = {data_high, data_low};

always @(posedge clk) begin
    valid_out_reg <= 1'b0;
end

endmodule