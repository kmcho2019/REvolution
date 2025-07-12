module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [3:0] encoded_state;

    // Priority encoder for the current state
    always @(*) begin
        encoded_state = 4'b0;
        if (state[9]) encoded_state = 4'd9;
        else if (state[8]) encoded_state = 4'd8;
        else if (state[7]) encoded_state = 4'd7;
        else if (state[6]) encoded_state = 4'd6;
        else if (state[5]) encoded_state = 4'd5;
        else if (state[4]) encoded_state = 4'd4;
        else if (state[3]) encoded_state = 4'd3;
        else if (state[2]) encoded_state = 4'd2;
        else if (state[1]) encoded_state = 4'd1;
        else if (state[0]) encoded_state = 4'd0;
    end

    // Next state logic using multiplexers
    always @(*) begin
        next_state = 10'b0;
        case (encoded_state)
            4'd0: next_state[in ? 1 : 0] = 1'b1;
            4'd1: next_state[in ? 2 : 0] = 1'b1;
            4'd2: next_state[in ? 3 : 0] = 1'b1;
            4'd3: next_state[in ? 4 : 0] = 1'b1;
            4'd4: next_state[in ? 5 : 0] = 1'b1;
            4'd5: next_state[in ? 6 : 8] = 1'b1;
            4'd6: next_state[in ? 7 : 9] = 1'b1;
            4'd7: begin
                next_state[in ? 7 : 0] = 1'b1;
                out2 = 1'b1;
            end
            4'd8: begin
                next_state[in ? 1 : 0] = 1'b1;
                out1 = 1'b1;
            end
            4'd9: begin
                next_state[in ? 1 : 0] = 1'b1;
                out1 = 1'b1;
                out2 = 1'b1;
            end
            default: next_state[0] = 1'b1; // Default to S0 if not encoded
        endcase
    end

endmodule