module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] cnt;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00; // IDLE state
        cnt <= 2'b00;
        sum <= 10'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state <= 2'b01; // transition to ACCUMULATE state
                    cnt <= 2'b01;
                    sum <= data_in;
                end
            end
            2'b01: begin // ACCUMULATE state
                if (valid_in) begin
                    cnt <= cnt + 1'b1;
                    sum <= sum + data_in;
                    if (cnt == 2'b11) begin // accumulated four values
                        state <= 2'b00; // transition back to IDLE state
                        valid_out <= 1'b1;
                        data_out <= sum;
                    end
                end
            end
            default: state <= 2'b00;
        endcase
        if (state == 2'b00 && valid_out) begin
            valid_out <= 1'b0; // set valid_out to 0 after one cycle
        end
    end
end

endmodule