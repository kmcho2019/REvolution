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
reg [3:0] pattern;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 2'b01; // Transition to SHIFT state
                    shift_count <= 2'b00;
                end
            end
            2'b01: begin // SHIFT state
                shift_ena <= 1'b1;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin
                    state <= 2'b10; // Transition to COUNTING state
                    shift_ena <= 1'b0;
                end
            end
            2'b10: begin // COUNTING state
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 2'b11; // Transition to DONE state
                end
            end
            2'b11: begin // DONE state
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    state <= 2'b00; // Transition to IDLE state
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule