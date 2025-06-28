module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// State definitions
parameter WAIT = 2'd0;
parameter FIRST_BYTE = 2'd1;
parameter SECOND_BYTE = 2'd2;
parameter DONE = 2'd3;

// State and next state variables
reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= WAIT;
        done <= 0;
    end else begin
        state <= next_state;
        done <= (next_state == DONE);
    end
end

// Next state logic
always @* begin
    case(state)
        WAIT: begin
            if (in[3] == 1)
                next_state = FIRST_BYTE;
            else
                next_state = WAIT;
        end
        FIRST_BYTE: begin
            if (in[3] == 1)
                next_state = SECOND_BYTE;
            else
                next_state = WAIT;
        end
        SECOND_BYTE: begin
            if (in[3] == 1)
                next_state = DONE;
            else
                next_state = WAIT;
        end
        DONE: begin
            next_state = WAIT;
        end
        default: next_state = WAIT;
    endcase
end

endmodule