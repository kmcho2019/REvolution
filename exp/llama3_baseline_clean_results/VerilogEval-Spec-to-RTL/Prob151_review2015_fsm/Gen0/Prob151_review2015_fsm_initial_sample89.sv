module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [3:0] pattern;
reg [3:0] shift_count;

assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        pattern <= 4'b0000;
        shift_count <= 4'b0000;
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
                shift_count <= shift_count + 1;
                if (shift_count == 4'b0100) begin
                    state <= 2'b10;
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
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule