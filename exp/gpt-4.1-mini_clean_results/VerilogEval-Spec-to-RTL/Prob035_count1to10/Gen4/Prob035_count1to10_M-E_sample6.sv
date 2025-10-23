module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] one_hot_state; // one-hot encoded counter: only one bit set at a time

    // Next state logic: rotate the '1' bit left, wrap around
    wire [9:0] next_state = {one_hot_state[8:0], one_hot_state[9]};

    // Combinational logic to encode one_hot_state to binary count (1 to 10)
    // Since only one bit is set, index of set bit + 1 = count
    integer i;
    reg [3:0] encoded_count;
    always @(*) begin
        encoded_count = 4'd0;
        for (i = 0; i < 10; i = i + 1) begin
            if (one_hot_state[i])
                encoded_count = i + 1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            one_hot_state <= 10'b0000000001;  // synchronous reset to count = 1
        end else begin
            one_hot_state <= next_state;      // rotate one-hot bit to next state
        end
        q <= encoded_count;
    end

endmodule