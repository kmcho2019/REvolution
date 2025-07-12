module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

    // One-hot encoded state for count 0 to 9
    reg [9:0] state;

    // Next state combinational logic: rotate '1' to next bit, wrap around
    wire [9:0] next_state;
    assign next_state = {state[8:0], state[9]}; // rotate left by 1 bit

    // Synchronous process for state register with active high synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // reset to count 0 (one-hot)
        else
            state <= next_state;
    end

    // Combinational decoding of one-hot state to binary output q
    // Use a function to convert one-hot vector to binary index
    function [3:0] one_hot_to_binary;
        input [9:0] one_hot_val;
        integer i;
        begin
            one_hot_to_binary = 4'd0;
            for (i = 0; i < 10; i = i + 1) begin
                if (one_hot_val[i])
                    one_hot_to_binary = i[3:0];
            end
        end
    endfunction

    assign q = one_hot_to_binary(state);

endmodule