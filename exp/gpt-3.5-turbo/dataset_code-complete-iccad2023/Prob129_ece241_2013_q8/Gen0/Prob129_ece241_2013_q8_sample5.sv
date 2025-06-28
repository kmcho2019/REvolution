module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

// Define states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

// Define state and next state registers
reg [1:0] state, next_state;

// Define output logic
always @ (*)
begin
    case (state)
        S0: begin
            next_state = (x) ? S1 : S0;
            z = 0;
        end
        
        S1: begin
            next_state = (x) ? S2 : S0;
            z = 0;
        end
        
        S2: begin
            next_state = (x) ? S1 : S0;
            z = x; // Output z is High when "101" detected
        end
    endcase
end

// Synchronous state transition
always @(posedge clk or negedge aresetn)
begin
    if (~aresetn)
        state <= S0;
    else
        state <= next_state;
end

endmodule