module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define the states
reg [1:0] current_state;
reg [1:0] next_state;

// Define the states as parameters
parameter OFF = 2'b00;
parameter ON = 2'b01;

// Combinational logic for next state
always @(*)
begin
    case(current_state)
        OFF:
        begin
            if(j)
                next_state = ON;
            else
                next_state = OFF;
        end
        ON:
        begin
            if(k)
                next_state = OFF;
            else
                next_state = ON;
        end
        default:
            next_state = OFF;
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset)
begin
    if(areset)
        current_state <= OFF;
    else
        current_state <= next_state;
end

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule