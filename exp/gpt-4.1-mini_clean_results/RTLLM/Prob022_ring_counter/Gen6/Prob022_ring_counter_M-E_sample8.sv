module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [2:0] index;  // 3-bit index to track position 0-7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 3'b000;
        end else begin
            if (index == 3'd7)
                index <= 3'b000;
            else
                index <= index + 3'b001;
        end
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
            default: out = 8'b00000001; // default fallback
        endcase
    end

endmodule