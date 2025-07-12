module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state; // 2-state FSM: idle (0) and accumulation (1, 2, 3)
reg [9:0] sum; // 10-bit register to store accumulated sum
reg [1:0] count; // counter to track number of valid inputs

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if (valid_in) begin
                state = 2'b01; // transition to accumulation state
                sum = data_in; // initialize sum with first input
                count = 1'b1; // initialize count to 1
                valid_out = 1'b0; // reset valid_out
            end else begin
                state = 2'b00; // stay in idle state
            end
        end
        2'b01: begin // accumulation state (1 input received)
            if (valid_in) begin
                state = 2'b10; // transition to next state
                sum = sum + data_in; // accumulate sum
                count = count + 1'b1; // increment count
            end else begin
                state = 2'b01; // stay in current state
            end
        end
        2'b10: begin // accumulation state (2 inputs received)
            if (valid_in) begin
                state = 2'b11; // transition to next state
                sum = sum + data_in; // accumulate sum
                count = count + 1'b1; // increment count
            end else begin
                state = 2'b10; // stay in current state
            end
        end
        2'b11: begin // accumulation state (3 inputs received)
            if (valid_in) begin
                state = 2'b00; // transition back to idle state
                sum = sum + data_in; // accumulate sum
                count = count + 1'b1; // increment count
                valid_out = 1'b1; // set valid_out to 1
                data_out = sum; // output accumulated sum
            end else begin
                state = 2'b11; // stay in current state
            end
        end
        default: state = 2'b00; // default to idle state
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        sum <= 10'b0;
        count <= 2'b00;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        // do nothing, all signals are combinational
    end
end

always @(posedge clk) begin
    if (state == 2'b00 && valid_in == 1'b0) begin
        valid_out <= 1'b0; // reset valid_out after one cycle
    end
end

endmodule