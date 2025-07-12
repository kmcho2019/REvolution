module fsm(
    input  IN,
    input  CLK,
    input  RST,
    output MATCH
);

// Define the states
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Initialize the current state
initial current_state = S0;

// State transitions
always @(*) begin
    case(current_state)
        S0: begin
            if (IN == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (IN == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (IN == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (IN == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (IN == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
    endcase
end

// Update the current state on the positive edge of the clock or reset
always @(posedge CLK or posedge RST) begin
    if (RST == 1'b1) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign MATCH = (current_state == S5 && IN == 1'b1)? 1'b1 : 1'b0;

endmodule