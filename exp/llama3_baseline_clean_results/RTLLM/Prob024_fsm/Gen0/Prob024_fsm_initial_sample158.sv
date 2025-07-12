module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
reg [2:0] state;
localparam S0 = 3'b000; // Initial state
localparam S1 = 3'b001; // Seen 1
localparam S2 = 3'b010; // Seen 10
localparam S3 = 3'b011; // Seen 100
localparam S4 = 3'b100; // Seen 1001
localparam S5 = 3'b101; // Seen 10011 (MATCH state)

// State transition logic
always @(*) begin
    case(state)
        S0: begin
            if(IN) state = S1;
            else state = S0;
        end
        S1: begin
            if(!IN) state = S2;
            else state = S1;
        end
        S2: begin
            if(!IN) state = S3;
            else state = S1; // Restart from S1 if input is 1
        end
        S3: begin
            if(IN) state = S4;
            else state = S2; // Go back to S2 if 0, expecting 100
        end
        S4: begin
            if(IN) state = S5;
            else state = S1; // If 0 after 1001, restart from S1
        end
        S5: begin
            if(IN) state = S5; // Stay in S5 if input is 1
            else state = S1; // If 0 after 10011, restart from S1
        end
        default: state = S0;
    endcase
end

// Output logic (Mealy machine)
always @(*) begin
    if(state == S5 && IN) MATCH = 1;
    else MATCH = 0;
end

// Synchronous reset
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        // No need to explicitly update state here as it's done in the always @(*) block.
        // MATCH is updated based on state and IN in the always @(*) block.
    end
end

endmodule