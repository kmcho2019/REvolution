module TopModule(
    input clk,
    input reset,
    input in,
    output reg out // Declare out as reg to allow procedural assignment
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state
reg [1:0] current_state;

// Combine next state and output logic into one always block for efficiency
always @(posedge clk)
begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
        endcase
    end
end

// Output is determined solely by the current state
always @(current_state)
begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule