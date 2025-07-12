module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

// Next state logic
always @(IN, current_state) begin
    case (current_state)
        S0: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

// Output logic
always @(current_state, IN) begin
    if ((current_state == S4) && (IN == 1'b1))
        MATCH = 1'b1;
    else
        MATCH = 1'b0;
end

// State update logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule