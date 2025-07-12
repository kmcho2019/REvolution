module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    always @(*) begin
        next_state = 10'b0;
        out1 = 1'b0;
        out2 = 1'b0;

        if (state[0] || state[8] || state[9]) begin
            next_state[in ? 1 : 0] = 1'b1;
            if (state[8] || state[9]) out1 = 1'b1;
        end else if (state[7]) begin
            next_state[in ? 7 : 0] = 1'b1;
            out2 = 1'b1;
        end else if (state[5]) begin
            next_state[in ? 6 : 8] = 1'b1;
        end else if (state[6]) begin
            next_state[in ? 7 : 9] = 1'b1;
        end else if (state[1] || state[2] || state[3] || state[4]) begin
            next_state[in ? (state[1] ? 2 : state[2] ? 3 : state[3] ? 4 : 5) : 0] = 1'b1;
        end
    end

endmodule