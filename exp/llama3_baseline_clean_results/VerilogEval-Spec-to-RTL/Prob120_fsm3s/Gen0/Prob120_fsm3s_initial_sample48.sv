module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states as parameters
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state and next state
reg [1:0] current_state, next_state;

// Assign output based on current state
always @(*)
begin
    case(current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if(reset)
    begin
        current_state <= A;
    end
    else
    begin
        case(current_state)
            A: 
            begin
                if(!in)
                    current_state <= A;
                else
                    current_state <= B;
            end
            B: 
            begin
                if(!in)
                    current_state <= C;
                else
                    current_state <= B;
            end
            C: 
            begin
                if(!in)
                    current_state <= A;
                else
                    current_state <= D;
            end
            D: 
            begin
                if(!in)
                    current_state <= C;
                else
                    current_state <= B;
            end
        endcase
    end
end

endmodule