module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter S0 = 4'b0000, // Initial state
           S1 = 4'b0001, // Sequence: 1
           S2 = 4'b0010, // Sequence: 10
           S3 = 4'b0100, // Sequence: 100
           S4 = 4'b1000; // Sequence: 1001

reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
reg match;

// Assign output
assign MATCH = match;

// Combinational logic for next state
always @(*) begin
    case(current_state)
        S0: begin
            if (IN) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (!IN) next_state = S2;
            else next_state = S1;
        end
        S2: begin
            if (!IN) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if (IN) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (IN) next_state = S4;
            else next_state = S0;
            match = 1'b1; // Set match in this state when IN is 1
        end
        default: next_state = S0;
    endcase
end

// Sequential logic for state register
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        match <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4 && IN) match <= 1'b1;
        else match <= 1'b0;
    end
end

endmodule