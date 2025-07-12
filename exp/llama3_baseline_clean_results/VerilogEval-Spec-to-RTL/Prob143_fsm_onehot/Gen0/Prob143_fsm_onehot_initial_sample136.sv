module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Initialize next_state and outputs
assign next_state = 10'b0;
assign out1 = 1'b0;
assign out2 = 1'b0;

// S0
always @(state or in) begin
    if (state[0]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
    end
end

// S1
always @(state or in) begin
    if (state[1]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[2] = 1'b1;
        end
    end
end

// S2
always @(state or in) begin
    if (state[2]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[3] = 1'b1;
        end
    end
end

// S3
always @(state or in) begin
    if (state[3]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[4] = 1'b1;
        end
    end
end

// S4
always @(state or in) begin
    if (state[4]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[5] = 1'b1;
        end
    end
end

// S5
always @(state or in) begin
    if (state[5]) begin
        if (!in) begin
            next_state[8] = 1'b1;
        end else begin
            next_state[6] = 1'b1;
        end
    end
end

// S6
always @(state or in) begin
    if (state[6]) begin
        if (!in) begin
            next_state[9] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
        end
    end
end

// S7
always @(state or in) begin
    if (state[7]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[7] = 1'b1;
            out1 = 1'b0;
            out2 = 1'b1;
        end
    end
end

// S8
always @(state or in) begin
    if (state[8]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b0;
    end
end

// S9
always @(state or in) begin
    if (state[9]) begin
        if (!in) begin
            next_state[0] = 1'b1;
        end else begin
            next_state[1] = 1'b1;
        end
        out1 = 1'b1;
        out2 = 1'b1;
    end
end

endmodule