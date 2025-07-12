module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state; // 0: idle, 1: accumulate, 2: output
reg [1:0] count; // count of valid data inputs
reg [9:0] sum; // accumulated sum

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
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
                end
            end
            1: begin // accumulate state
                if (valid_in) begin
                    if (count < 4) begin
                        count <= count + 1;
                        sum <= sum + data_in;
                    end else begin
                        state <= 2;
                        data_out <= sum;
                    end
                end
            end
            2: begin // output state
                valid_out <= 1;
                state <= 0;
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state != 2) begin
        valid_out <= 0;
    end
end

endmodule