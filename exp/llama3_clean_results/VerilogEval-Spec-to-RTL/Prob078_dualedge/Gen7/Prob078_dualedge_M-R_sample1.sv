module TopModule(
    input clk,
    input d,
    output reg q
);

reg [1:0] state; // State machine with 2 states for positive and negative edges
reg q_pos;       // Output of positive-edge triggered flip-flop
reg q_neg;       // Output of negative-edge triggered flip-flop

// State machine to handle clock edges
always @(posedge clk or negedge clk) begin
    case(state)
        2'b00: begin // Initial state or after positive edge
            if (~clk) begin // Moving to negative edge
                state <= 2'b01;
                q_neg <= d;
            end else begin // Staying at positive edge
                state <= 2'b00;
                q_pos <= d;
            end
        end
        2'b01: begin // After negative edge
            if (clk) begin // Moving to positive edge
                state <= 2'b00;
                q_pos <= d;
            end else begin // Staying at negative edge
                state <= 2'b01;
                q_neg <= d;
            end
        end
        default: state <= 2'b00; // Reset state
    endcase
end

// Continuous assignment to select output based on clock edge
assign q = (clk == 1'b1)? q_pos : q_neg;

endmodule