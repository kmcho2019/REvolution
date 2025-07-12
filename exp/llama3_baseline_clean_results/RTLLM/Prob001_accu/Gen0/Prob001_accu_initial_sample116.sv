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
        state <= 2'b00; // idle state
        count <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (valid_in) begin
                    state <= 2'b01; // accumulation state
                    count <= 1'b1;
                    sum <= data_in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // accumulation state
                if (valid_in) begin
                    count <= count + 1'b1;
                    sum <= sum + data_in;
                    if (count == 4'b100) begin
                        state <= 2'b10; // output state
                    end
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin // output state
                valid_out <= 1'b1;
                data_out <= sum;
                state <= 2'b00; // back to idle state
                count <= 2'b00;
                sum <= 10'b0;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

always @(*) begin
    if (state != 2'b10) begin
        valid_out = 1'b0;
    end
end

endmodule