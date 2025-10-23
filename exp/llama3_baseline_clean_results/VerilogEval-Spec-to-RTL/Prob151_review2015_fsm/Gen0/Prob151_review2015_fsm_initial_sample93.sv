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

reg [1:0] state, next_state;
reg [3:0] shift_count;
reg [3:0] pattern_reg;
reg pattern_detected;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (pattern_detected) begin
                next_state = 2'b01; // Transition to SHIFT
            end else begin
                next_state = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // SHIFT
            if (shift_count == 4) begin
                next_state = 2'b10; // Transition to COUNTING
            end else begin
                next_state = 2'b01; // Stay in SHIFT
            end
        end
        2'b10: begin // COUNTING
            if (done_counting) begin
                next_state = 2'b11; // Transition to DONE
            end else begin
                next_state = 2'b10; // Stay in COUNTING
            end
        end
        2'b11: begin // DONE
            if (ack) begin
                next_state = 2'b00; // Transition back to IDLE
            end else begin
                next_state = 2'b11; // Stay in DONE
            end
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        pattern_reg <= 4'b0000;
        shift_count <= 4'b0000;
        pattern_detected <= 1'b0;
    end else begin
        state <= next_state;
        pattern_reg <= {data, pattern_reg[3:1]};
        if (state == 2'b01) begin
            shift_count <= shift_count + 1;
        end else begin
            shift_count <= 4'b0000;
        end
        if (pattern_reg == 4'b1101 && state == 2'b00) begin
            pattern_detected <= 1'b1;
        end else if (state == 2'b01) begin
            pattern_detected <= 1'b0;
        end
    end
end

assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

endmodule