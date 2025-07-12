module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg [9:0] sum;
reg [2:0] counter;
reg [7:0] data_buffer [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        sum <= 10'd0;
        counter <= 3'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state <= 2'b01;
                    data_buffer[0] <= data_in;
                    counter <= 3'd1;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // ACCUMULATE state
                if (valid_in && counter < 3'd4) begin
                    case (counter)
                        3'd1: data_buffer[1] <= data_in;
                        3'd2: data_buffer[2] <= data_in;
                        3'd3: data_buffer[3] <= data_in;
                    endcase
                    counter <= counter + 3'd1;
                end
                if (counter == 3'd4) begin
                    sum <= data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];
                    state <= 2'b10;
                end
            end
            2'b10: begin // OUTPUT state
                valid_out <= 1'b1;
                data_out <= sum;
                state <= 2'b00;
                valid_out <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2'b10) begin
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule