module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;
    end else begin
        case (state)
            8'b0000_0001: state <= 8'b0000_0010;
            8'b0000_0010: state <= 8'b0000_0100;
            8'b0000_0100: state <= 8'b0000_1000;
            8'b0000_1000: state <= 8'b0001_0000;
            8'b0001_0000: state <= 8'b0010_0000;
            8'b0010_0000: state <= 8'b0100_0000;
            8'b0100_0000: state <= 8'b1000_0000;
            8'b1000_0000: state <= 8'b0000_0001;
            default: state <= 8'b0000_0001;
        endcase
    end
end

assign out = state;

endmodule