module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

// Define states
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

reg [3:0] current_state;
reg [3:0] next_state;

// Set initial state
initial begin
    current_state = S0;
end

// Set next state based on current state and input
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
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (IN == 1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

// Update current state on positive edge of clock or reset
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == S5 && IN == 1) begin
            MATCH <= 1;
        end else begin
            MATCH <= 0;
        end
    end
end

endmodule