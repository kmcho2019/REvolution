module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (state)
        A: 
            if (r[0] == 1'b1) begin
                next_state = B;
            end
            else if (r[1] == 1'b1) begin
                next_state = C;
            end
            else if (r[2] == 1'b1) begin
                next_state = D;  // However, according to the problem, 
                                // state D is not defined with a g output
                                // and the initial state should have no g output
                                // So the original logic for this condition 
                                // is incorrect, it should not be 
                                // changing the state in this case
                next_state = A;
            end
            else begin
                next_state = A;
            end
        B: 
            if (r[0] == 1'b1) begin
                next_state = B;
            end
            else begin
                next_state = A;
            end
        C: 
            if (r[1] == 1'b1) begin
                next_state = C;
            end
            else begin
                next_state = A;
            end
        D: begin  // Added an additional state
            next_state = A;
        end
        default: 
            next_state = A;
    endcase
end

// State flip-flop
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end
    else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (state)
        A: 
            g <= 3'b000;
        B: 
            g <= 3'b100;
        C: 
            g <= 3'b010;
        D: 
            g <= 3'b000;
        default: 
            g <= 3'b000;
    endcase
end

endmodule