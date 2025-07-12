module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
    endcase
    
    // Determine the output based on the current state
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state; // Update the current state
    end
end

endmodule