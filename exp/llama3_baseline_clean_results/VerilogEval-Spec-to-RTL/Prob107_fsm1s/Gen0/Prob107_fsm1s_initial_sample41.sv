module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
reg [1:0] state; // 0: A, 1: B
reg [1:0] next_state;

// Assign outputs based on states
always @(state) begin
    case (state)
        2'b0: out = 1'b0; // State A
        2'b1: out = 1'b1; // State B
        default: out = 1'bx;
    endcase
end

// State transitions
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b1; // Reset state is B
    end else begin
        case (state)
            2'b0: begin // State A
                if (~in) begin
                    state <= 2'b1; // A -> B
                end else begin
                    state <= 2'b0; // A -> A
                end
            end
            2'b1: begin // State B
                if (~in) begin
                    state <= 2'b1; // B -> B
                end else begin
                    state <= 2'b1; // B -> B
                end
            end
            default: state <= 2'bx;
        endcase
    end
end

endmodule