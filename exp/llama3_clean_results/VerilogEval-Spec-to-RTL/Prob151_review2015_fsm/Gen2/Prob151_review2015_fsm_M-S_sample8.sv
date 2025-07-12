module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
reg [1:0] shift_count;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_count <= 2'b00;
        pattern <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= 2'b01;
                    shift_count <= 2'b00;
                    shift_ena <= 1'b1;
                end else begin
                    shift_ena <= 1'b0;
                end
            end
            2'b01: begin // Shift
                shift_count <= shift_count + 1'b1;
                if (shift_count == 4'd4) begin
                    state <= 2'b10;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                end
            end
            2'b10: begin // Counting
                if (done_counting) begin
                    state <= 2'b11;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            2'b11: begin // Done
                if (ack) begin
                    state <= 2'b00;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule