module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        counter <= 0;
        sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (valid_in) begin
                    state <= 1;
                    counter <= 1;
                    sum <= data_in;
                end else begin
                    state <= 0;
                end
            end
            1: begin // accumulating state
                if (valid_in) begin
                    counter <= counter + 1;
                    sum <= sum + data_in;
                    if (counter == 4) begin
                        state <= 2;
                    end
                end else begin
                    state <= 1;
                end
            end
            2: begin // output state
                valid_out <= 1;
                data_out <= sum;
                state <= 3;
            end
            3: begin // reset state
                valid_out <= 0;
                state <= 0;
                counter <= 0;
                sum <= 0;
            end
        endcase
    end
end

endmodule