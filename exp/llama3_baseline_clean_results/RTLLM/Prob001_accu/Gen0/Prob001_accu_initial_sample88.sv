module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state; // 0: idle, 1: counting, 2: output
reg [7:0] data_accum [0:3]; // accumulate 4 input data
reg [1:0] count; // count valid input data
reg [9:0] sum; // accumulated sum

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        count <= 0;
        sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (valid_in) begin
                    state <= 1;
                    data_accum[0] <= data_in;
                    count <= 1;
                end
            end
            1: begin // counting
                if (valid_in) begin
                    if (count == 4) begin
                        state <= 2;
                        sum <= data_accum[0] + data_accum[1] + data_accum[2] + data_accum[3];
                    end else begin
                        data_accum[count] <= data_in;
                        count <= count + 1;
                    end
                end
            end
            2: begin // output
                state <= 0;
                valid_out <= 1;
                data_out <= sum;
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (state != 2) begin
        valid_out <= 0;
    end
end

endmodule