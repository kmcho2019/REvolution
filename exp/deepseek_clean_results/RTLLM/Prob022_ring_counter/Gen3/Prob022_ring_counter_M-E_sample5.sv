module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Define states as positions in the ring
parameter [2:0] STATE_0 = 3'b000,
                STATE_1 = 3'b001,
                STATE_2 = 3'b010,
                STATE_3 = 3'b011,
                STATE_4 = 3'b100,
                STATE_5 = 3'b101,
                STATE_6 = 3'b110,
                STATE_7 = 3'b111;

reg [2:0] current_state;

// State transition logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= STATE_0;
    end
    else begin
        case (current_state)
            STATE_0: current_state <= STATE_1;
            STATE_1: current_state <= STATE_2;
            STATE_2: current_state <= STATE_3;
            STATE_3: current_state <= STATE_4;
            STATE_4: current_state <= STATE_5;
            STATE_5: current_state <= STATE_6;
            STATE_6: current_state <= STATE_7;
            STATE_7: current_state <= STATE_0;
            default: current_state <= STATE_0;
        endcase
    end
end

// Output decoding (state to one-hot)
always @(*) begin
    case (current_state)
        STATE_0: out = 8'b00000001;
        STATE_1: out = 8'b00000010;
        STATE_2: out = 8'b00000100;
        STATE_3: out = 8'b00001000;
        STATE_4: out = 8'b00010000;
        STATE_5: out = 8'b00100000;
        STATE_6: out = 8'b01000000;
        STATE_7: out = 8'b10000000;
        default: out = 8'b00000001;
    endcase
end

endmodule