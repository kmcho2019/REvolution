module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [2:0] shift_count;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_count <= 3'b000;
        pattern <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (data == 1'b1 && pattern == 4'b1101) begin
                    state <= 2'b01;
                    pattern <= 4'b0000;
                end else if (data == 1'b1) begin
                    pattern <= {data, pattern[3:1]};
                end else begin
                    pattern <= {data, pattern[3:1]};
                end
            end
            2'b01: begin // SHIFT state
                shift_ena <= 1'b1;
                shift_count <= shift_count + 1;
                if (shift_count == 3'b100) begin
                    shift_ena <= 1'b0;
                    state <= 2'b10;
                    shift_count <= 3'b000;
                end
            end
            2'b10: begin // COUNT state
                counting <= 1'b1;
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= 2'b11;
                end
            end
            2'b11: begin // DONE state
                done <= 1'b1;
                if (ack) begin
                    done <= 1'b0;
                    state <= 2'b00;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

assign shift_ena = (state == 2'b01) ? 1'b1 : 1'b0;
assign counting = (state == 2'b10) ? 1'b1 : 1'b0;
assign done = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule