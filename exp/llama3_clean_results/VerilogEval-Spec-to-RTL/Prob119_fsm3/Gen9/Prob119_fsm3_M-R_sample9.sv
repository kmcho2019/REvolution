module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
reg [1:0] state;

// Assign output based on current state
assign out = (state == 2'b11)? 1'b1 : 1'b0;

// Define the next state logic directly
reg [1:0] next_state;
assign next_state = 
    (state == 2'b00 &&!in)? 2'b00 :
    (state == 2'b00 &&  in)? 2'b01 :
    (state == 2'b01 &&!in)? 2'b10 :
    (state == 2'b01 &&  in)? 2'b01 :
    (state == 2'b10 &&!in)? 2'b00 :
    (state == 2'b10 &&  in)? 2'b11 :
    (state == 2'b11 &&!in)? 2'b10 :
    (state == 2'b11 &&  in)? 2'b01 : 2'b00;

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule