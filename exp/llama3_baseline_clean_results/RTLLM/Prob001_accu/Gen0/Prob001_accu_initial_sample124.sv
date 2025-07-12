module accu (
    input  clk,
    input  rst_n,
    input  [7:0] data_in,
    input  valid_in,
    output reg  valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] count;
reg [9:0] sum;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        count <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state <= 2'b01; // ACCUMULATE state
                    count <= 2'b01;
                    sum <= data_in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // ACCUMULATE state
                if (valid_in) begin
                    count <= count + 1'b1;
                    sum <= sum + data_in;
                    if (count == 2'b11) begin
                        state <= 2'b00; // IDLE state
                        valid_out <= 1'b1;
                        data_out <= sum;
                    end else begin
                        state <= 2'b01;
                    end
                end else begin
                    state <= 2'b01;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
        if (state == 2'b00 && valid_out == 1'b1) begin
            valid_out <= 1'b0;
        end
    end
end

endmodule