module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0] state;
reg [1:0] count;
reg [9:0] accu_sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // idle state
        count <= 2'b00;
        accu_sum <= 10'b0;
        valid_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (valid_in) begin
                    state <= 2'b01; // accumulating state
                    count <= 2'b01;
                    accu_sum <= data_in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // accumulating state
                if (valid_in) begin
                    count <= count + 1'b1;
                    accu_sum <= accu_sum + data_in;
                    if (count == 2'b11) begin
                        state <= 2'b00; // back to idle state
                        valid_out <= 1'b1;
                        data_out <= accu_sum;
                    end
                end else begin
                    state <= 2'b01;
                end
            end
            default: state <= 2'b00;
        endcase
        if (state == 2'b00 && count != 2'b11) begin
            valid_out <= 1'b0;
        end else if (state == 2'b00 && count == 2'b11) begin
            valid_out <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 1'b0;
    end
end

endmodule