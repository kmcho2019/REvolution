module TopModule(
    input  [5:0] y,  // current one-hot state vector: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    reg [5:0] next_state;

    always @(*) begin
        next_state = 6'b000000; // default no next state
        
        // State A (y[0])
        if (y[0]) begin
            if (w == 1'b0)
                next_state[1] = 1'b1; // B
            else
                next_state[0] = 1'b1; // A
        end

        // State B (y[1])
        else if (y[1]) begin
            if (w == 1'b0)
                next_state[2] = 1'b1; // C
            else
                next_state[3] = 1'b1; // D
        end

        // State C (y[2])
        else if (y[2]) begin
            if (w == 1'b0)
                next_state[4] = 1'b1; // E
            else
                next_state[3] = 1'b1; // D
        end

        // State D (y[3])
        else if (y[3]) begin
            if (w == 1'b0)
                next_state[5] = 1'b1; // F
            else
                next_state[0] = 1'b1; // A
        end

        // State E (y[4])
        else if (y[4]) begin
            if (w == 1'b0)
                next_state[4] = 1'b1; // E
            else
                next_state[3] = 1'b1; // D
        end

        // State F (y[5])
        else if (y[5]) begin
            if (w == 1'b0)
                next_state[2] = 1'b1; // C
            else
                next_state[3] = 1'b1; // D
        end
    end

    // Outputs are the next state bits for B (y[1]) and D (y[3])
    assign Y2 = next_state[1];
    assign Y4 = next_state[3];

endmodule