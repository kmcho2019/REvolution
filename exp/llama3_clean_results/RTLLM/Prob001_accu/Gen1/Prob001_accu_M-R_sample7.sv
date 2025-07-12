module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter; // counter to track the number of valid inputs
reg [9:0] accumulated_sum; // register to store the accumulated sum
reg state; // state machine state (0: IDLE, 1: ACCUMULATE)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        accumulated_sum <= 0;
        valid_out <= 0;
        data_out <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (valid_in) begin
                    state <= 1;
                    accumulated_sum <= data_in;
                    counter <= 1;
                    valid_out <= 0;
                end else begin
                    state <= 0;
                    valid_out <= 0;
                end
            end
            1: begin // ACCUMULATE state
                if (valid_in && counter < 4) begin
                    accumulated_sum <= accumulated_sum + data_in;
                    counter <= counter + 1;
                    valid_out <= 0;
                end else if (counter == 4 && valid_in) begin
                    data_out <= accumulated_sum + data_in;
                    valid_out <= 1;
                    counter <= 0;
                    accumulated_sum <= 0;
                    state <= 0;
                end else begin
                    valid_out <= 0;
                    state <= 0;
                end
            end
        endcase
    end
end

// reset valid_out after one cycle
always @(posedge clk) begin
    if (valid_out) begin
        valid_out <= 0;
    end
end

endmodule