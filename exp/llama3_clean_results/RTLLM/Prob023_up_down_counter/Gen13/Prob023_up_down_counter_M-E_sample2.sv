module up_down_counter (
    input clk,         // Clock signal
    input reset,       // Reset signal
    input up_down,     // Control signal for counting direction
    output reg [15:0] count  // 16-bit output representing the current counter value
);

reg [15:0] inc_counter;
reg [15:0] dec_counter;
reg [1:0] state; // 0 - Reset, 1 - Increment, 2 - Decrement

always @ (posedge clk) begin
    case (state)
        2'b00: begin // RESET
            inc_counter <= 16'd0;
            dec_counter <= 16'd0;
            if (~reset) begin
                state <= up_down ? 2'b01 : 2'b10;
            end
        end
        2'b01: begin // INCREMENT
            inc_counter <= inc_counter + 1;
            if (inc_counter == 16'd65535) begin
                inc_counter <= 16'd0;
            end
            if (reset || ~up_down) begin
                state <= 2'b00;
            end
        end
        2'b10: begin // DECREMENT
            dec_counter <= dec_counter - 1;
            if (dec_counter == 16'd0) begin
                dec_counter <= 16'd65535;
            end
            if (reset || up_down) begin
                state <= 2'b00;
            end
        end
        default: state <= 2'b00;
    endcase
end

always @ (*) begin
    case (state)
        2'b00: count = 16'd0;
        2'b01: count = inc_counter;
        2'b10: count = dec_counter;
        default: count = 16'd0;
    endcase
end

endmodule