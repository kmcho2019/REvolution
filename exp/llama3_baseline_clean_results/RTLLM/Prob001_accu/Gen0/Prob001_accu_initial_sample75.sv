module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state; // 2 states: idle (0), accumulation (1)
reg [1:0] count; // count of valid input data received
reg [9:0] sum; // accumulated sum of input data
reg valid_out_reg; // registered valid_out signal

// state machine
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0; // reset to idle state
        count <= 0; // reset count
        sum <= 0; // reset sum
        valid_out_reg <= 0; // reset valid_out signal
    end else begin
        case (state)
            0: begin // idle state
                if (valid_in) begin
                    state <= 1; // transition to accumulation state
                    count <= 1; // increment count
                    sum <= data_in; // initialize sum with first input data
                end else begin
                    state <= 0; // stay in idle state
                end
            end
            1: begin // accumulation state
                if (valid_in) begin
                    count <= count + 1; // increment count
                    sum <= sum + data_in; // accumulate sum
                    if (count == 3) begin // four valid input data received
                        state <= 0; // transition back to idle state
                        valid_out_reg <= 1; // set valid_out signal
                    end else begin
                        state <= 1; // stay in accumulation state
                    end
                end else begin
                    state <= 0; // transition back to idle state
                end
            end
            default: state <= 0;
        endcase
    end
end

// output logic
assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg)? sum : 0;

// clear valid_out signal after one cycle
always @ (posedge clk) begin
    if (valid_out_reg) begin
        valid_out_reg <= 0;
    end
end

endmodule