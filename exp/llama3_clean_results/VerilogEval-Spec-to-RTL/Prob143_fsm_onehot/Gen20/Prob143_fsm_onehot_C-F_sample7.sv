module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        if (state[0] || state[8] || state[9]) begin
            next_state = (in)? 10'b0000000010 : 10'b0000000001;
            if (state[8] || state[9]) out1 = 1'b1;
            if (state[9]) out2 = 1'b1;
        end else if (state[1]) next_state = (in)? 10'b0000000100 : 10'b0000000001;
        else if (state[2]) next_state = (in)? 10'b0000001000 : 10'b0000000001;
        else if (state[3]) next_state = (in)? 10'b0000010000 : 10'b0000000001;
        else if (state[4]) next_state = (in)? 10'b0000100000 : 10'b0000000001;
        else if (state[5]) next_state = (in)? 10'b0001000000 : 10'b1000000000;
        else if (state[6]) next_state = (in)? 10'b0010000000 : 10'b0100000000;
        else if (state[7]) begin
            next_state = (in)? 10'b0010000000 : 10'b0000000001;
            out2 = 1'b1;
        end
    end

endmodule