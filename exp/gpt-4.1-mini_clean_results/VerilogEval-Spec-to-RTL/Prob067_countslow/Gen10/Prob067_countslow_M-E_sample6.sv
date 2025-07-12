module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [9:0] one_hot_state;

    // On reset, initialize to count 0 (bit 0 set)
    always @(posedge clk) begin
        if (reset) begin
            one_hot_state <= 10'b0000000001;
        end else if (slowena) begin
            // Rotate left by one with wrap-around
            one_hot_state <= {one_hot_state[8:0], one_hot_state[9]};
        end
    end

    // Combinational logic: convert one_hot_state to binary count q
    always @(*) begin
        case (one_hot_state)
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
            default: q = 4'd0; // default safe value, should not occur
        endcase
    end

endmodule