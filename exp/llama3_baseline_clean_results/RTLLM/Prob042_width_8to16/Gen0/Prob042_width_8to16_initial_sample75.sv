module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] data_lock;
reg [1:0] state;
reg [7:0] data_temp;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // idle state
        data_out <= 16'b0;
        data_lock <= 8'b0;
        valid_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (valid_in) begin
                    data_lock <= data_in;
                    state <= 2'b01; // wait_for_second_data state
                    valid_out <= 1'b0;
                end else begin
                    valid_out <= 1'b0;
                end
            end
            2'b01: begin // wait_for_second_data state
                if (valid_in) begin
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    state <= 2'b00; // idle state
                end else begin
                    valid_out <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // idle state
                valid_out <= 1'b0;
            end
        endcase
    end
end

endmodule