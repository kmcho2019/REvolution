module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg     [1:0]       state;
reg     [9:0]       sum;
reg     [1:0]       count;
reg                 valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state       <= 2'b00;
        sum         <= 10'b0;
        count       <= 2'b00;
        valid_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (valid_in) begin
                    state       <= 2'b01;
                    sum         <= data_in;
                    count       <= 2'b01;
                    valid_out_reg <= 1'b0;
                end else begin
                    state       <= 2'b00;
                    valid_out_reg <= 1'b0;
                end
            end
            2'b01: begin
                if (valid_in) begin
                    if (count == 2'b11) begin
                        sum         <= sum + data_in;
                        state       <= 2'b10;
                        valid_out_reg <= 1'b1;
                    end else begin
                        sum         <= sum + data_in;
                        count       <= count + 1'b1;
                        valid_out_reg <= 1'b0;
                    end
                end else begin
                    state       <= 2'b01;
                    valid_out_reg <= 1'b0;
                end
            end
            2'b10: begin
                state       <= 2'b00;
                count       <= 2'b00;
                valid_out_reg <= 1'b0;
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out  = sum;

endmodule