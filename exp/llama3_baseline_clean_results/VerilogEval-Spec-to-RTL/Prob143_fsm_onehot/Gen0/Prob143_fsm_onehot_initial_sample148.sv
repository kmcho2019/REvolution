module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state to zero
assign next_state = 10'b0000000000;

// Initialize outputs to zero
assign out1 = 1'b0;
assign out2 = 1'b0;

// State S0
if (state[0]) begin
    if (in) begin
        assign next_state[1] = 1'b1; // Go to S1
    end else begin
        assign next_state[0] = 1'b1; // Stay at S0
    end
end

// State S1
if (state[1]) begin
    if (in) begin
        assign next_state[2] = 1'b1; // Go to S2
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S2
if (state[2]) begin
    if (in) begin
        assign next_state[3] = 1'b1; // Go to S3
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S3
if (state[3]) begin
    if (in) begin
        assign next_state[4] = 1'b1; // Go to S4
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S4
if (state[4]) begin
    if (in) begin
        assign next_state[5] = 1'b1; // Go to S5
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S5
if (state[5]) begin
    if (in) begin
        assign next_state[6] = 1'b1; // Go to S6
    end else begin
        assign next_state[8] = 1'b1; // Go to S8
    end
end

// State S6
if (state[6]) begin
    if (in) begin
        assign next_state[7] = 1'b1; // Go to S7
    end else begin
        assign next_state[9] = 1'b1; // Go to S9
    end
end

// State S7
if (state[7]) begin
    assign out1 = 1'b0;
    assign out2 = 1'b1;
    if (in) begin
        assign next_state[7] = 1'b1; // Stay at S7
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S8
if (state[8]) begin
    assign out1 = 1'b1;
    assign out2 = 1'b0;
    if (in) begin
        assign next_state[1] = 1'b1; // Go to S1
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

// State S9
if (state[9]) begin
    assign out1 = 1'b1;
    assign out2 = 1'b1;
    if (in) begin
        assign next_state[1] = 1'b1; // Go to S1
    end else begin
        assign next_state[0] = 1'b1; // Go to S0
    end
end

endmodule