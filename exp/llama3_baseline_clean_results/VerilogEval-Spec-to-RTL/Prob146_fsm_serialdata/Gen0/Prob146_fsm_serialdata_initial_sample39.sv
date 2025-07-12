module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), START (1), RECEIVE_DATA (2), STOP (3, 4, 5, 6, 7)
reg [2:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // IDLE state
        done_reg <= 0;
        out_byte_reg <= 0;
        counter <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE state
                if (~in) begin // start bit detected
                    state_reg <= 1; // START state
                end
            end
            1: begin // START state
                state_reg <= 2; // RECEIVE_DATA state
                counter <= 0; // reset counter for data bits
            end
            2: begin // RECEIVE_DATA state
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift in data bit
                counter <= counter + 1;
                if (counter == 7) begin
                    state_reg <= 3; // STOP state
                end
            end
            3: begin // STOP state
                if (in) begin // correct stop bit detected
                    done_reg <= 1;
                    state_reg <= 0; // IDLE state
                end else begin // incorrect stop bit, wait for stop bit
                    state_reg <= 4; // wait for stop bit
                end
            end
            4: begin // wait for stop bit
                if (in) begin
                    state_reg <= 0; // IDLE state
                end
            end
            default: begin
                state_reg <= 0; // IDLE state
            end
        endcase
        if (state_reg == 0 && ~in) begin // going back to IDLE state, reset done
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule