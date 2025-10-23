module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Define the current state register
reg [2:0] current_state;
reg [2:0] next_state;

// Define the output z
assign z = (current_state == E) | (current_state == F);

// Combinational logic to determine the next state
always @(*) begin
    case(current_state)
        A: next_state = w? A : B;
        B: next_state = w? D : C;
        C: next_state = w? D : E;
        D: next_state = w? A : F;
        E: next_state = w? D : E;
        F: next_state = w? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic to store the current state and update it on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule