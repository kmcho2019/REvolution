module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define the states
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;

// Initialize the current state and MATCH
reg [3:0] current_state;
reg match;

// Set the initial state and MATCH
initial begin
    current_state = S0;
    match = 0;
end

// Update the current state and MATCH on every positive edge of CLK or RST
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        match <= 0;
    end
    else begin
        case (current_state)
            S0: begin
                if (IN) begin
                    current_state <= S1;
                end
                else begin
                    current_state <= S0;
                end
            end
            S1: begin
                if (!IN) begin
                    current_state <= S2;
                end
                else begin
                    current_state <= S1;
                end
            end
            S2: begin
                if (!IN) begin
                    current_state <= S3;
                end
                else begin
                    current_state <= S1;
                end
            end
            S3: begin
                if (IN) begin
                    current_state <= S4;
                end
                else begin
                    current_state <= S0;
                end
            end
            S4: begin
                if (IN) begin
                    current_state <= S5;
                end
                else begin
                    current_state <= S0;
                end
            end
            S5: begin
                match <= 1;
                if (IN) begin
                    current_state <= S1;
                end
                else begin
                    current_state <= S0;
                end
            end
            default: begin
                current_state <= S0;
            end
        endcase
    end
end

// Update MATCH when the current state is S5
always @(current_state) begin
    if (current_state == S5) begin
        match <= 1;
    end
    else begin
        match <= 0;
    end
end

// Assign the output MATCH
assign MATCH = match;

endmodule