module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    // One-hot encoded state register: bit0=state0, bit1=state1, bit2=state2, bit3=state3
    reg [3:0] state_oh;
    reg [3:0] next_state_oh;

    // Asynchronous reset sets state to 2'b01 (state 1), thus one-hot bit1=1
    // Saturating increment/decrement moves the '1' in the vector left/right with saturation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // increment saturates at state 3 (bit3)
                if (state_oh[3])
                    next_state_oh = 4'b1000;
                else if (state_oh[2])
                    next_state_oh = 4'b1000;
                else if (state_oh[1])
                    next_state_oh = 4'b0100;
                else // state_oh[0]
                    next_state_oh = 4'b0010;
            end else begin
                // decrement saturates at state 0 (bit0)
                if (state_oh[0])
                    next_state_oh = 4'b0001;
                else if (state_oh[1])
                    next_state_oh = 4'b0001;
                else if (state_oh[2])
                    next_state_oh = 4'b0010;
                else // state_oh[3]
                    next_state_oh = 4'b0100;
            end
        end else begin
            // hold current state
            next_state_oh = state_oh;
        end
    end

    // Sequential logic with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to weakly not-taken state 1, one-hot encoding 4'b0010
            state_oh <= 4'b0010;
        end else begin
            state_oh <= next_state_oh;
        end
    end

    // Decode one-hot to binary 2-bit state
    always @(*) begin
        case (state_oh)
            4'b0001: state = 2'b00;
            4'b0010: state = 2'b01;
            4'b0100: state = 2'b10;
            4'b1000: state = 2'b11;
            default: state = 2'b01; // default to weakly not-taken on invalid encoding
        endcase
    end

endmodule