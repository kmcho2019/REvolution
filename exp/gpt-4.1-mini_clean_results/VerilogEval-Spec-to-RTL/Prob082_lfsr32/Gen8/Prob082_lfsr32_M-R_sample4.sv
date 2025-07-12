module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = 32'h80200003; // bits 31,21,1,0 taps

    // Function to compute the feedback bit based on current q and taps
    function logic feedback_bit(input [31:0] state);
        logic fb;
        integer i;
        begin
            fb = state[0];
            // XOR feedback with taps where bits are set in TAP_MASK (except LSB)
            for (i = 1; i < 32; i = i + 1) begin
                if (TAP_MASK[i]) fb = fb ^ state[i];
            end
            feedback_bit = fb;
        end
    endfunction

    wire fb = feedback_bit(q);

    wire [31:0] next_q = {fb, q[31:1]};

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule