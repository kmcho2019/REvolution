`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [3:0] state;

initial state = 4'b0001;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0001;
    end else begin
        case (state)
            4'b0001: state <= in ? 4'b0010 : 4'b0001;
            4'b0010: state <= in ? 4'b0010 : 4'b0100;
            4'b0100: state <= in ? 4'b1000 : 4'b0001;
            4'b1000: state <= in ? 4'b0010 : 4'b0100;
        endcase
    end
end

always @(*) begin
    case (state)
        4'b0001, 4'b0010, 4'b0100: out = 0;
        4'b1000: out = 1;
    endcase
end

endmodule