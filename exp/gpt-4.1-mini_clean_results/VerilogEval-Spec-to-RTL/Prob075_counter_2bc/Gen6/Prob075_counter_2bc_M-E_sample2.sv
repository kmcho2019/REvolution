module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    // One-hot encoded state: 4 bits representing counter states 0..3
    reg [3:0] onehot_state, next_onehot;

    // On reset, set to '01' which corresponds to state index 1 (2'b01)
    // Initialize onehot_state to 4'b0010 (state = 1)
    always @(*) begin
        if (!train_valid) begin
            next_onehot = onehot_state; // hold current state if no training
        end else begin
            if (train_taken) begin
                // Increment saturating at max (3)
                if (onehot_state[3]) // already at max
                    next_onehot = onehot_state;
                else
                    next_onehot = onehot_state << 1;
            end else begin
                // Decrement saturating at min (0)
                if (onehot_state[0]) // already at min
                    next_onehot = onehot_state;
                else
                    next_onehot = onehot_state >> 1;
            end
        end
    end

    // Sequential logic with asynchronous reset (posedge areset)
    always @(posedge clk or posedge areset) begin
        if (areset)
            onehot_state <= 4'b0010; // corresponds to state '01'
        else
            onehot_state <= next_onehot;
    end

    // Decode one-hot to binary state output
    always @(*) begin
        case (onehot_state)
            4'b0001: state = 2'd0;
            4'b0010: state = 2'd1;
            4'b0100: state = 2'd2;
            4'b1000: state = 2'd3;
            default: state = 2'd0; // should never happen but safe default
        endcase
    end

endmodule