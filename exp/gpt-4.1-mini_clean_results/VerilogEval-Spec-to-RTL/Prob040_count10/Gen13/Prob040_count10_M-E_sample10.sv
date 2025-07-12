module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // One-hot state register: 10 bits, only one bit is high at a time
    reg [9:0] one_hot;

    // Next state logic: rotate the '1' in one_hot by 1 bit
    wire [9:0] one_hot_next;

    // Rotate left by 1 bit with wrap-around
    assign one_hot_next = {one_hot[8:0], one_hot[9]};

    // Synchronous process for one-hot state register
    always @(posedge clk) begin
        if (reset)
            one_hot <= 10'b0000000001; // count = 0
        else
            one_hot <= one_hot_next;
    end

    // Combinational logic to encode the one-hot vector into binary count q
    always @(*) begin
        case (one_hot)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default: q = 4'd0; // safety default
        endcase
    end

endmodule