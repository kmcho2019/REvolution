module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] index; // 3-bit index to track position of the '1'

    always @(posedge clk or posedge reset) begin
        if (reset)
            index <= 3'd0;
        else
            index <= index + 3'd1;
    end

    always @(*) begin
        case (index)
            3'd0: out = 8'b00000001;
            3'd1: out = 8'b00000010;
            3'd2: out = 8'b00000100;
            3'd3: out = 8'b00001000;
            3'd4: out = 8'b00010000;
            3'd5: out = 8'b00100000;
            3'd6: out = 8'b01000000;
            3'd7: out = 8'b10000000;
            default: out = 8'b00000001; // default safe value
        endcase
    end

endmodule