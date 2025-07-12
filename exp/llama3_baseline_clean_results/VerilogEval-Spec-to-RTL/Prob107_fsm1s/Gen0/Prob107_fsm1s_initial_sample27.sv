module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
reg [1:0] state;
reg [1:0] next_state;

// State encoding
parameter A = 2'b00;
parameter B = 2'b01;

// State transition logic
always @(posedge clk) begin
    if(reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'bx; // Default case to handle unknown state
    endcase
end

// Next state logic
always @(*) begin
    case(state)
        B: if(in == 1'b0) next_state = A;
           else next_state = B;
        A: if(in == 1'b0) next_state = B;
           else next_state = A;
        default: next_state = 2'bx; // Default case to handle unknown state
    endcase
end

endmodule