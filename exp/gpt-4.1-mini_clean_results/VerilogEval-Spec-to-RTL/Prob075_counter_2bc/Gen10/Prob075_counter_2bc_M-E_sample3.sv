module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // One-hot encoded state for 4 states: [3 2 1 0]
    reg [3:0] state_oh, next_state_oh;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_oh <= 4'b0010;  // corresponds to state=1 (2'b01)
        else if (train_valid)
            state_oh <= next_state_oh;
        else
            state_oh <= state_oh;
    end

    // Next state logic based on train_taken and saturating boundaries
    always @* begin
        if (train_taken) begin
            // Increment saturating shift left
            if (state_oh[3])
                next_state_oh = 4'b1000;  // stay at max (state 3)
            else
                next_state_oh = state_oh << 1;
        end else begin
            // Decrement saturating shift right
            if (state_oh[0])
                next_state_oh = 4'b0001;  // stay at min (state 0)
            else
                next_state_oh = state_oh >> 1;
        end
    end

    // Decode one-hot state back to binary
    always @* begin
        case (state_oh)
            4'b0001: state = 2'd0;
            4'b0010: state = 2'd1;
            4'b0100: state = 2'd2;
            4'b1000: state = 2'd3;
            default: state = 2'd1; // default to weakly not-taken on invalid encoding
        endcase
    end

endmodule