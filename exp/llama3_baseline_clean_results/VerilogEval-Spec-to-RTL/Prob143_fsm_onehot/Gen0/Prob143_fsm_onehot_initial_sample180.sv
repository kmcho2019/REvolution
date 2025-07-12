module TopModule(
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

always @(*) begin
    next_state = 10'b0;
    out1 = 1'b0;
    out2 = 1'b0;

    if(state[0] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
    end

    if(state[1] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[2] = 1'b1;
        end
    end

    if(state[2] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[3] = 1'b1;
        end
    end

    if(state[3] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[4] = 1'b1;
        end
    end

    if(state[4] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[5] = 1'b1;
        end
    end

    if(state[5] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[8] = 1'b1;
        end else begin
            next_state[6] = 1'b1;
        end
    end

    if(state[6] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[9] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
        end
    end

    if(state[7] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end

    if(state[8] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end

    if(state[9] == 1'b1) begin
        if(in == 1'b0) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end

    // If a state bit is 1, the corresponding next_state bit is set to 1
    for (int i = 0; i < 10; i++) begin
        if (state[i] == 1'b1) begin
            next_state[i] = next_state[i] | state[i];
        end
    end
end

endmodule