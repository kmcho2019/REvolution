module accu (
    input           clk, 
    input           rst_n, 
    input   [7:0]    data_in, 
    input           valid_in, 
    output          valid_out, 
    output  [9:0]    data_out
);

reg     [1:0]    state;  // 0: idle, 1: accumulating, 2: output
reg     [9:0]    accu_sum;  // accumulated sum
reg     [1:0]    cnt;  // count of valid data received
reg             valid_out_reg;  // registered valid_out signal

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        accu_sum <= 0;
        cnt <= 0;
        valid_out_reg <= 0;
    end else begin
        case (state)
            0: begin  // idle state
                if (valid_in) begin
                    state <= 1;
                    accu_sum <= data_in;
                    cnt <= 1;
                end
            end
            1: begin  // accumulating state
                if (valid_in) begin
                    accu_sum <= accu_sum + data_in;
                    cnt <= cnt + 1;
                    if (cnt == 4) begin
                        state <= 2;
                    end
                end else begin
                    // do nothing
                end
            end
            2: begin  // output state
                valid_out_reg <= 1;
                state <= 0;
            end
            default: begin
                // do nothing
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = (state == 2) ? accu_sum : 0;

endmodule