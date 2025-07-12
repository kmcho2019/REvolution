module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as parameters
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the state register
reg [2:0] state;
reg [2:0] next_state;

// Define the counter for the linear progression
reg [1:0] counter;
reg [1:0] next_counter;

// Combinational logic for the counter
always @(*) begin
    case (counter)
        2'b00: next_counter = (w == 1)? 2'b00 : 2'b01;
        2'b01: next_counter = (w == 1)? 2'b10 : 2'b10;
        2'b10: next_counter = (w == 1)? 2'b11 : 2'b11;
        2'b11: next_counter = (w == 1)? 2'b11 : 2'b11;
        default: next_counter = 2'b00;
    endcase
end

// Combinational logic for the Mealy machine
always @(*) begin
    case (state)
        A: next_state = (w == 1)? A : B;
        B: next_state = (w == 1)? D : C;
        C: next_state = (w == 1)? D : E;
        D: next_state = (w == 1)? A : F;
        E: next_state = (w == 1)? D : E;
        F: next_state = (w == 1)? D : C;
        default: next_state = A;
    endcase
end

// Combinational logic for output z
assign z = (state == E) || (state == F);

// Update the state and counter on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        counter <= 2'b00;
    end
    else begin
        state <= next_state;
        counter <= next_counter;
    end
end

endmodule