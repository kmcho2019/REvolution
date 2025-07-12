module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [9:0] sum;
reg [1:0] counter;
reg [9:0] pipeline_data;
reg pipeline_valid;

// FSM state transitions
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00; // IDLE state
        sum <= 10'b0;
        counter <= 2'b00;
        pipeline_data <= 10'b0;
        pipeline_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state <= 2'b01; // ACCUMULATE state
                    sum <= data_in;
                    counter <= 2'b01;
                end
            end
            2'b01: begin // ACCUMULATE state
                if (valid_in) begin
                    sum <= sum + data_in;
                    counter <= counter + 1'b1;
                    if (counter == 2'b11) begin
                        state <= 2'b10; // OUTPUT state
                        pipeline_data <= sum;
                        pipeline_valid <= 1'b1;
                    end
                end
            end
            2'b10: begin // OUTPUT state
                valid_out <= pipeline_valid;
                data_out <= pipeline_data;
                state <= 2'b00; // IDLE state
                pipeline_valid <= 1'b0;
            end
            default: begin
                state <= 2'b00; // IDLE state
            end
        endcase
    end
end

endmodule