module fsm(
    input IN,
    input CLK,
    input RST,
    output MATCH
);

// Define states
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

// Current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Assign output
assign MATCH = (current_state == S5) && (IN == 1);

// State transition logic
always @(*) begin
    case (current_state)
        S0: begin
            if (IN == 1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 0) begin
                next_state = S3;
            end else begin
                next_state = S2;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S3;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S4;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else if (IN == 0) begin
                next_state = S2;
            end
        end
        default: next_state = S0;
    endcase

    if (RST == 1) begin
        next_state = S0;
    end
end

// Sequential logic
always @(posedge CLK) begin
    if (RST == 1) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

endmodule