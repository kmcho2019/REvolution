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

reg [1:0] state;  // 2-bit state variable
reg [3:0] count;  // counter for bits shifted
reg [3:0] pattern;  // detected pattern

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;  // IDLE state
        count <= 0;
        pattern <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            2'b00: begin  // IDLE state
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 2'b01;  // transition to SHIFT state
                end
            end
            2'b01: begin  // SHIFT state
                shift_ena <= 1;
                count <= count + 1;
                if (count == 4) begin
                    state <= 2'b10;  // transition to COUNT state
                    shift_ena <= 0;
                end
            end
            2'b10: begin  // COUNT state
                counting <= 1;
                if (done_counting) begin
                    state <= 2'b11;  // transition to DONE state
                    counting <= 0;
                    done <= 1;
                end
            end
            2'b11: begin  // DONE state
                if (ack) begin
                    state <= 2'b00;  // transition back to IDLE state
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule