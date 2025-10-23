module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: state <= 3'b001;
            3'b001: state <= 3'b010;
            3'b010: state <= 3'b011;
            3'b011: state <= 3'b100;
            3'b100: state <= 3'b101;
            3'b101: state <= 3'b110;
            3'b110: state <= 3'b111;
            3'b111: state <= 3'b000;
            default: state <= 3'b000;
        endcase
    end
end

// One-hot decoder
always @(*) begin
    out = 8'b00000001 << state;
end

endmodule