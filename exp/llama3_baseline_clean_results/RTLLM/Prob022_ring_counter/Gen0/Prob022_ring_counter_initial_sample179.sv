module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        out <= 8'b0000_0001;
    end else begin
        if (state == 3'b111) begin
            state <= 3'b000;
        end else begin
            state <= state + 1'b1;
        end
        case (state)
            3'b000: out <= 8'b0000_0001;
            3'b001: out <= 8'b0000_0010;
            3'b010: out <= 8'b0000_0100;
            3'b011: out <= 8'b0000_1000;
            3'b100: out <= 8'b0001_0000;
            3'b101: out <= 8'b0010_0000;
            3'b110: out <= 8'b0100_0000;
            3'b111: out <= 8'b1000_0000;
            default: out <= 8'b0000_0000;
        endcase
    end
end

endmodule