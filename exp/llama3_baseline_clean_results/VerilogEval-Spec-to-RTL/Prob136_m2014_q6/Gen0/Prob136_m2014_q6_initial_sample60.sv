module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the register to hold the current state
reg [2:0] current_state;

// Define the output 'z' based on the current state
always @(current_state) begin
    case (current_state)
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Define the next state logic
reg [2:0] next_state;
always @(*) begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A; // default state
    endcase
end

// Define the sequential logic to update the current state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule