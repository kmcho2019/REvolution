module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] pattern;
reg [1:0] shift_cnt;
reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_cnt <= 2'b00;
        pattern <= 4'b0000;
    end
    else begin
        case (state)
            2'b00: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin
                if (shift_cnt == 4) begin
                    state <= 2'b10;
                end
                else begin
                    shift_cnt <= shift_cnt + 1;
                end
            end
            2'b10: begin
                if (done_counting) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin
                if (ack) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule