module TopModule (
    input  in,
    input  [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to all zeros
assign next_state = 10'b0000000000;

// Initialize out1 and out2 to zero
assign out1 = 0;
assign out2 = 0;

// Check if state S0 is active
if (state[0] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[1] = 1;
    end
end

// Check if state S1 is active
if (state[1] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[2] = 1;
    end
end

// Check if state S2 is active
if (state[2] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[3] = 1;
    end
end

// Check if state S3 is active
if (state[3] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[4] = 1;
    end
end

// Check if state S4 is active
if (state[4] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[5] = 1;
    end
end

// Check if state S5 is active
if (state[5] == 1) begin
    if (in == 0) begin
        next_state[8] = 1;
    end else begin
        next_state[6] = 1;
    end
end

// Check if state S6 is active
if (state[6] == 1) begin
    if (in == 0) begin
        next_state[9] = 1;
    end else begin
        next_state[7] = 1;
    end
end

// Check if state S7 is active
if (state[7] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[7] = 1;
    end
    out2 = 1;
end

// Check if state S8 is active
if (state[8] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[1] = 1;
    end
    out1 = 1;
end

// Check if state S9 is active
if (state[9] == 1) begin
    if (in == 0) begin
        next_state[0] = 1;
    end else begin
        next_state[1] = 1;
    end
    out1 = 1;
    out2 = 1;
end

endmodule