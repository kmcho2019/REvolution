module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state; // 2-state FSM: idle (0) and accumulation (1)
reg [1:0] count; // count of valid data received
reg [9:0] accu_sum; // accumulated sum of valid data

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // idle state
        count <= 0;
        accu_sum <= 0;
        valid_out <= 0;
        data_out <= 0;
    end else begin
        case (state)
            0: begin // idle state
                if (valid_in) begin
                    state <= 1; // transition to accumulation state
                    count <= 1;
                    accu_sum <= data_in;
                    valid_out <= 0;
                    data_out <= 0;
                end else begin
                    state <= 0; // stay in idle state
                    count <= 0;
                    accu_sum <= 0;
                    valid_out <= 0;
                    data_out <= 0;
                end
            end
            1: begin // accumulation state
                if (valid_in) begin
                    count <= count + 1;
                    accu_sum <= accu_sum + data_in;
                    if (count == 4) begin
                        state <= 0; // transition back to idle state
                        valid_out <= 1;
                        data_out <= accu_sum;
                    end else begin
                        state <= 1; // stay in accumulation state
                        valid_out <= 0;
                        data_out <= 0;
                    end
                end else begin
                    state <= 1; // stay in accumulation state
                    count <= count;
                    accu_sum <= accu_sum;
                    valid_out <= 0;
                    data_out <= 0;
                end
            end
            default: begin
                state <= 0; // default to idle state
                count <= 0;
                accu_sum <= 0;
                valid_out <= 0;
                data_out <= 0;
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (valid_out) begin
        valid_out <= 0; // reset valid_out after one cycle
    end
end

endmodule