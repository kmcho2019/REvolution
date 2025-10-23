module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;

    always @(*) begin
        case (state)
            2'b00: begin
                if (train_valid) begin
                    if (train_taken)
                        next_state = 2'b01;      // increment from 0 to 1
                    else
                        next_state = 2'b00;      // saturate at 0
                end else begin
                    next_state = state;
                end
            end
            2'b01: begin
                if (train_valid) begin
                    if (train_taken)
                        next_state = 2'b10;      // increment from 1 to 2
                    else
                        next_state = 2'b00;      // decrement from 1 to 0
                end else begin
                    next_state = state;
                end
            end
            2'b10: begin
                if (train_valid) begin
                    if (train_taken)
                        next_state = 2'b11;      // increment from 2 to 3
                    else
                        next_state = 2'b01;      // decrement from 2 to 1
                end else begin
                    next_state = state;
                end
            end
            2'b11: begin
                if (train_valid) begin
                    if (train_taken)
                        next_state = 2'b11;      // saturate at 3
                    else
                        next_state = 2'b10;      // decrement from 3 to 2
                end else begin
                    next_state = state;
                end
            end
            default: begin
                next_state = 2'b01;  // Default to weakly not taken if out of range
            end
        endcase
    end

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // reset state to weakly not taken
        else
            state <= next_state;
    end

endmodule