module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Decode the current state into individual state signals
reg [9:0] s;
assign s = state;

// Initialize the next state signals
reg [9:0] next_state_logic;
assign next_state = next_state_logic;

// State transition logic
always @(*) begin
    next_state_logic = 10'b0; // Initialize next_state_logic to 0
    out1 = 1'b0; // Initialize out1 to 0
    out2 = 1'b0; // Initialize out2 to 0

    if (s[0]) begin // S0
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Stay in S0
        end else begin
            next_state_logic[1] = 1'b1; // Go to S1
        end
    end else if (s[1]) begin // S1
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[2] = 1'b1; // Go to S2
        end
    end else if (s[2]) begin // S2
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[3] = 1'b1; // Go to S3
        end
    end else if (s[3]) begin // S3
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[4] = 1'b1; // Go to S4
        end
    end else if (s[4]) begin // S4
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[5] = 1'b1; // Go to S5
        end
    end else if (s[5]) begin // S5
        if (in == 1'b0) begin
            next_state_logic[8] = 1'b1; // Go to S8
        end else begin
            next_state_logic[6] = 1'b1; // Go to S6
        end
    end else if (s[6]) begin // S6
        if (in == 1'b0) begin
            next_state_logic[9] = 1'b1; // Go to S9
        end else begin
            next_state_logic[7] = 1'b1; // Go to S7
        end
    end else if (s[7]) begin // S7
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[7] = 1'b1; // Stay in S7
            out2 = 1'b1; // Set out2 to 1
        end
    end else if (s[8]) begin // S8
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[1] = 1'b1; // Go to S1
        end
        out1 = 1'b1; // Set out1 to 1
    end else if (s[9]) begin // S9
        if (in == 1'b0) begin
            next_state_logic[0] = 1'b1; // Go to S0
        end else begin
            next_state_logic[1] = 1'b1; // Go to S1
        end
        out1 = 1'b1; // Set out1 to 1
        out2 = 1'b1; // Set out2 to 1
    end
end

endmodule