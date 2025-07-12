module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state; // 2-bit state register (00: idle, 01: accumulate, 10: output)
reg [1:0] count; // 2-bit counter for valid inputs
reg [9:0] accu_sum; // 10-bit register for accumulated sum
reg valid_out_reg; // register for valid_out signal

// assign valid_out
assign valid_out = valid_out_reg;

// reset logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        count <= 2'b00;
        accu_sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle state
                if (valid_in) begin
                    state <= 2'b01;
                    count <= 2'b01;
                    accu_sum <= data_in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // accumulation state
                if (valid_in) begin
                    count <= count + 1'b1;
                    accu_sum <= accu_sum + data_in;
                    if (count == 2'b11) begin // 4 valid inputs received
                        state <= 2'b10;
                    end else begin
                        state <= 2'b01;
                    end
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin // output state
                state <= 2'b00;
                valid_out_reg <= 1'b1;
            end
            default: state <= 2'b00;
        endcase
    end
end

// data_out logic
always @(posedge clk) begin
    if (state == 2'b10) begin
        data_out <= accu_sum;
    end else begin
        data_out <= 10'b0;
    end
    if (state != 2'b10) begin
        valid_out_reg <= 1'b0;
    end
end

endmodule