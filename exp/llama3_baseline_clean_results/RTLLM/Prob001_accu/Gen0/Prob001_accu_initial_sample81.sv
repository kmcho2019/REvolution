module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] count;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        count <= 0;
        sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (valid_in) begin
                    state <= 1;
                    count <= 1;
                    sum <= data_in;
                    valid_out <= 0;
                    data_out <= 0;
                end
            end
            1: begin // accumulation state
                if (valid_in) begin
                    count <= count + 1;
                    sum <= sum + data_in;
                    if (count == 4) begin
                        state <= 0;
                        valid_out <= 1;
                        data_out <= sum;
                    end else begin
                        valid_out <= 0;
                        data_out <= 0;
                    end
                end else begin
                    valid_out <= 0;
                    data_out <= 0;
                end
            end
            default: begin
                state <= 0;
                count <= 0;
                sum <= 0;
                valid_out <= 0;
                data_out <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule