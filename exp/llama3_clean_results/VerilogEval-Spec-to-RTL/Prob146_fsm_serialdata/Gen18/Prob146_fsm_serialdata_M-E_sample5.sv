module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [7:0] shift_reg;
reg [3:0] bit_counter;
reg state_idle;
reg state_receive;
reg state_stop;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_idle <= 1;
        state_receive <= 0;
        state_stop <= 0;
        bit_counter <= 0;
        shift_reg <= 8'b0;
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        case ({state_idle, state_receive, state_stop})
            3'b100: begin // IDLE state
                if (!in) begin // Start bit detected
                    state_idle <= 0;
                    state_receive <= 1;
                    bit_counter <= 1;
                    shift_reg <= {7'b0, in};
                end
            end
            3'b010: begin // RECEIVE state
                shift_reg <= {shift_reg[6:0], in}; // Shift new bit into the least significant position
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd9) begin // Complete byte received
                    state_receive <= 0;
                    state_stop <= 1;
                end
            end
            3'b001: begin // STOP state
                if (in) begin // Stop bit detected
                    out_byte <= shift_reg;
                    done <= 1;
                end
                state_stop <= 0;
                state_idle <= 1;
            end
        endcase
    end
end

// Reset done signal on the next clock cycle after it's set
always @(posedge clk) begin
    if (!state_stop || !in) begin
        done <= 0;
    end
end

endmodule