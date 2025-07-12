module ring_counter (
    input clk,
    input reset,
    output reg out0,
    output reg out1,
    output reg out2,
    output reg out3,
    output reg out4,
    output reg out5,
    output reg out6,
    output reg out7
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out0 <= 1'b1;
            out1 <= 1'b0;
            out2 <= 1'b0;
            out3 <= 1'b0;
            out4 <= 1'b0;
            out5 <= 1'b0;
            out6 <= 1'b0;
            out7 <= 1'b0;
        end else begin
            out0 <= out7;
            out1 <= out0;
            out2 <= out1;
            out3 <= out2;
            out4 <= out3;
            out5 <= out4;
            out6 <= out5;
            out7 <= out6;
        end
    end

endmodule