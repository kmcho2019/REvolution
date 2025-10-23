module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state;  // 1-bit state variable
reg [0:0] next_state;  // 1-bit next state variable

// Define states as parameters for clarity
parameter B = 1'b1, A = 1'b0;

// State machine's next state logic
always @(*)
begin
    case(state)
        B: 
            next_state = (in == 1'b0) ? A : B;
        A: 
            next_state = (in == 1'b0) ? B : A;
        default:
            next_state = B;  // Default state
    endcase
end

// State machine's output logic
always @(*)
begin
    case(state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b0;  // Default output
    endcase
end

// State update at clock edge, synchronous reset
always @(posedge clk or posedge reset)
begin
    if(reset) begin
        state <= B;  // Reset to state B
    end else begin
        state <= next_state;  // Update state at clock edge
    end
end

endmodule