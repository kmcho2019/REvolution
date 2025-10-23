module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Internal signal to hold the current state
reg current_state;

// Initialize the output based on the current state
always @(*)
begin
    case (current_state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
        default: out <= 1'b0; // Default to OFF if current_state is unknown
    endcase
end

// Next state logic
always @(posedge clk)
begin
    if (reset) // Active-high synchronous reset
    begin
        current_state <= OFF;
    end
    else
    begin
        case (current_state)
            OFF:
            begin
                if (j)
                begin
                    current_state <= ON;
                end
                else
                begin
                    current_state <= OFF;
                end
            end
            ON:
            begin
                if (k)
                begin
                    current_state <= OFF;
                end
                else
                begin
                    current_state <= ON;
                end
            end
            default:
            begin
                current_state <= OFF; // Default to OFF if current_state is unknown
            end
        endcase
    end
end

endmodule