module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire enable = train_valid;

    // Calculate increment and decrement conditions
    wire inc = enable & train_taken & (state != 2'b11);
    wire dec = enable & (~train_taken) & (state != 2'b00);

    // Next state logic using simple arithmetic with clamp
    wire [1:0] next_state = state + inc - dec;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (enable) begin
            state <= next_state;
        end
        // else hold state, no assignment needed as 'state' is reg
    end

endmodule