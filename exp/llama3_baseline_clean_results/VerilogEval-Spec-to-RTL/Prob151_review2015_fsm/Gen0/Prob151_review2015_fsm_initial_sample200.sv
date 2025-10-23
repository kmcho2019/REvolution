module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state; // IDLE (2'b00), SHIFT (2'b01), COUNT (2'b10), DONE (2'b11), ACK (2'b100)
reg [3:0] counter; // Counter for the SHIFT state
reg [3:0] pattern_counter; // Counter for the start sequence
reg [3:0] seq_reg; // Shift register for the start sequence

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        counter <= 4'd0;
        pattern_counter <= 4'd0;
        seq_reg <= 4'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (seq_reg == 4'b1101) begin
                    state <= 2'b01;
                    pattern_counter <= 4'd0;
                    seq_reg <= {seq_reg[2:0], data};
                end else begin
                    pattern_counter <= pattern_counter + 1'b1;
                    seq_reg <= {seq_reg[2:0], data};
                    if (pattern_counter == 4'd4) begin
                        pattern_counter <= 4'd0;
                        seq_reg <= 4'd0;
                    end
                end
            end
            2'b01: begin // SHIFT
                shift_ena <= 1'b1;
                counter <= counter + 1'b1;
                if (counter == 4'd4) begin
                    state <= 2'b10;
                    shift_ena <= 1'b0;
                end
            end
            2'b10: begin // COUNT
                counting <= 1'b1;
                if (done_counting) begin
                    state <= 2'b11;
                    counting <= 1'b0;
                end
            end
            2'b11: begin // DONE
                done <= 1'b1;
                if (ack) begin
                    state <= 2'b100;
                end
            end
            2'b100: begin // ACK
                done <= 1'b0;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule