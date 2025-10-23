module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states using one-hot encoding
reg [3:0] current_state;
wire [3:0] next_state;

// Initialize the state machine to state A
initial current_state = 4'b0001;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= 4'b0001; // Reset to state A
    end else begin
        case (current_state)
            4'b0001: // State A
                current_state <= (in) ? 4'b0010 : 4'b0001; // Next state B or A
            4'b0010: // State B
                current_state <= (in) ? 4'b0010 : 4'b0100; // Next state B or C
            4'b0100: // State C
                current_state <= (in) ? 4'b1000 : 4'b0001; // Next state D or A
            4'b1000: // State D
                current_state <= (in) ? 4'b0010 : 4'b0100; // Next state B or C
            default:
                current_state <= 4'b0001; // Default to state A
        endcase
    end
end

// Output logic
always @(current_state) begin
    case (current_state)
        4'b0001, 4'b0010, 4'b0100: // States A, B, C
            out = 1'b0;
        4'b1000: // State D
            out = 1'b1;
        default:
            out = 1'bx; // Default to unknown
    endcase
end

endmodule