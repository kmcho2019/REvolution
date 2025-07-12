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
reg [3:0] shift_count;
reg [3:0] pattern;
reg shift_ena_reg;
reg counting_reg;
reg done_reg;

// Pattern detector
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else begin
        pattern <= {pattern[2:0], data};
    end
end

// Finite state machine
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        shift_ena_reg <= 1'b0;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        shift_count <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (pattern == 4'b1101) begin
                    state <= 2'b01; // SHIFT state
                    shift_ena_reg <= 1'b1;
                    shift_count <= 4'b0001;
                end
            end
            2'b01: begin // SHIFT state
                shift_ena_reg <= (shift_count != 4'b1000);
                if (shift_count == 4'b1000) begin
                    state <= 2'b10; // COUNT state
                    counting_reg <= 1'b1;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2'b10: begin // COUNT state
                if (done_counting) begin
                    state <= 2'b11; // DONE state
                    done_reg <= 1'b1;
                    counting_reg <= 1'b0;
                end
            end
            2'b11: begin // DONE state
                if (ack) begin
                    state <= 2'b00; // IDLE state
                    done_reg <= 1'b0;
                end
            end
        endcase
    end
end

assign shift_ena = shift_ena_reg;
assign counting = counting_reg;
assign done = done_reg;

endmodule