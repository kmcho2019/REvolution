module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [9:0] state; // one-hot state encoding: only one bit high among 10 bits

    // On reset, state is set to 1-hot bit 0 representing count=1
    // On each clock, shift state left by 1, wrapping from MSB to LSB

    always @(posedge clk) begin
        if (reset)
            state <= 10'b0000000001; // count = 1
        else begin
            // shift left by 1; if MSB set, wrap to LSB
            if (state[9])
                state <= 10'b0000000001;
            else
                state <= state << 1;
        end
    end

    // combinational logic to decode one-hot state to binary count 1..10
    always @(*) begin
        case (1'b1)
            state[0]: q = 4'd1;
            state[1]: q = 4'd2;
            state[2]: q = 4'd3;
            state[3]: q = 4'd4;
            state[4]: q = 4'd5;
            state[5]: q = 4'd6;
            state[6]: q = 4'd7;
            state[7]: q = 4'd8;
            state[8]: q = 4'd9;
            state[9]: q = 4'd10;
            default:  q = 4'd1; // safe default
        endcase
    end

endmodule