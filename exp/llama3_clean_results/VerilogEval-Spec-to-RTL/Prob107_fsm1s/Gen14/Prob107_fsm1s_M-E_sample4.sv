module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state
reg [0:0] out_value; // Output value

// Look-up table for state transitions and output values
always @(*) begin
    case(state)
        0: begin // State B
            next_state = (in == 0) ? 1 : 0;
            out_value = 1'b1;
        end
        1: begin // State A
            next_state = (in == 0) ? 0 : 1;
            out_value = 1'b0;
        end
        default: begin
            next_state = 0; // Default to state B
            out_value = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B
    end else begin
        state <= next_state;
    end
    out <= out_value;
end

endmodule