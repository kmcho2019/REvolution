module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0]  data_out
);

reg [1:0] state;
reg [7:0] data_high;
reg [7:0] data_low;
reg data_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= 2'd0;
        data_high   <= 8'd0;
        data_low    <= 8'd0;
        data_valid  <= 1'b0;
        valid_out   <= 1'b0;
        data_out    <= 16'd0;
    end
    else begin
        case (state)
            2'd0: begin // IDLE
                if (valid_in) begin
                    data_high <= data_in;
                    state <= 2'd1;
                end
            end
            2'd1: begin // DATA_WAIT
                if (valid_in) begin
                    data_low <= data_in;
                    data_valid <= 1'b1;
                    state <= 2'd2;
                end
            end
            2'd2: begin // DATA_VALID
                data_out <= {data_high, data_low};
                valid_out <= 1'b1;
                data_valid <= 1'b0;
                state <= 2'd0;
            end
            default: state <= 2'd0;
        endcase
    end
end

endmodule