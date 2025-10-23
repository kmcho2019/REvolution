module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
parameter A = 1'b0;
parameter B = 1'b1;

// Define current state
reg current_state;

// Reset state to B when reset is high
always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        case (current_state)
            B: begin
                if (!in) begin
                    current_state <= A;
                end
            end
            A: begin
                if (!in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: current_state <= B;
        endcase
    end
end

// Determine output based on current state
always @(*) begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;
    endcase
end

endmodule