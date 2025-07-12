module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// One-hot encoded states (7 states: 0-6)
reg [6:0] state;

// State transition logic
always @(posedge clk) begin
    if (a) begin
        state <= 7'b0010000; // State 4 when a=1
    end
    else begin
        case (1'b1) // Priority encoder style
            state[4]: state <= 7'b0001000; // 4→5
            state[5]: state <= 7'b0000100; // 5→6
            state[6]: state <= 7'b0000001; // 6→0
            state[0]: state <= 7'b0000010; // 0→1
            state[1]: state <= 7'b0000100; // 1→2 (though never reached in given waveform)
            state[2]: state <= 7'b0001000; // 2→3 (though never reached in given waveform)
            state[3]: state <= 7'b0010000; // 3→4 (though never reached in given waveform)
            default:  state <= 7'b0010000; // Default to state 4
        endcase
    end
end

// Output encoding (one-hot to binary)
always @(*) begin
    case (1'b1)
        state[0]: q = 3'd0;
        state[1]: q = 3'd1;
        state[2]: q = 3'd2;
        state[3]: q = 3'd3;
        state[4]: q = 3'd4;
        state[5]: q = 3'd5;
        state[6]: q = 3'd6;
        default:  q = 3'd4;
    endcase
end

endmodule