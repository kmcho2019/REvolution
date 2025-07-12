module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

// Enum for the states
enum {Idle, Start, Data, Stop, Error} state, next_state;

// Reg to store the current state
reg [2:0] state_reg;

// Counter to keep track of the current data bit
reg [3:0] bit_count;

// Shift register to store the received data bits
reg [7:0] data_reg;

// Done signal
reg done_reg;

always @(*) begin
    // Default values
    next_state = state;
    done_reg = 1'b0;

    case(state)
        Idle: begin
            if (~in) begin
                next_state = Start;
            end
        end
        Start: begin
            next_state = Data;
            bit_count = 4'd0;
            data_reg = 8'd0;
        end
        Data: begin
            data_reg = {data_reg[6:0], in};
            if (bit_count == 4'd7) begin
                next_state = Stop;
            end else begin
                bit_count = bit_count + 1;
            end
        end
        Stop: begin
            if (in) begin
                // Successfully received a byte
                done_reg = 1'b1;
                next_state = Idle;
            end else begin
                next_state = Error;
            end
        end
        Error: begin
            if (in) begin
                next_state = Idle;
            end
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg = Idle;
        bit_count = 4'd0;
        data_reg = 8'd0;
        done_reg = 1'b0;
    end else begin
        state_reg = next_state;
        done = done_reg;
    end
end

assign state = state_reg;

endmodule