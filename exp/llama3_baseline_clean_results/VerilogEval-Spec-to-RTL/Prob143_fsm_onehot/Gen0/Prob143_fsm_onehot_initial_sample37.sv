module TopModule (
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'b0000000000;

    // Initialize output signals to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // Determine next state and output signals
    always @(*) begin
        // Initialize next_state to zero
        next_state = 10'b0000000000;
        
        // Evaluate state transition logic
        if (state[0] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
        end

        if (state[1] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[2] = 1'b1;
            end
        end

        if (state[2] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[3] = 1'b1;
            end
        end

        if (state[3] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[4] = 1'b1;
            end
        end

        if (state[4] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[5] = 1'b1;
            end
        end

        if (state[5] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[8] = 1'b1;
            end else begin
                next_state[6] = 1'b1;
            end
        end

        if (state[6] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[9] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
        end

        if (state[7] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[7] = 1'b1;
            end
            out2 = 1'b1;
        end

        if (state[8] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
            out1 = 1'b1;
        end

        if (state[9] == 1'b1) begin
            if (in == 1'b0) begin
                next_state[0] = 1'b1;
            end else begin
                next_state[1] = 1'b1;
            end
            out1 = 1'b1;
            out2 = 1'b1;
        end
    end

endmodule