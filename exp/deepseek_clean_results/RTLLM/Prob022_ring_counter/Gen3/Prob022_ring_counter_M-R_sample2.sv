module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;
    end
    else begin
        out <= next_state;
    end
end

always @(*) begin
    case (out)
        8'b00000001: next_state = 8'b00000010;
        8'b00000010: next_state = 8'b00000100;
        8'b00000100: next_state = 8'b00001000;
        8'b00001000: next_state = 8'b00010000;
        8'b00010000: next_state = 8'b00100000;
        8'b00100000: next_state = 8'b01000000;
        8'b01000000: next_state = 8'b10000000;
        8'b10000000: next_state = 8'b00000001;
        default: next_state = 8'b00000001;
    endcase
end

endmodule