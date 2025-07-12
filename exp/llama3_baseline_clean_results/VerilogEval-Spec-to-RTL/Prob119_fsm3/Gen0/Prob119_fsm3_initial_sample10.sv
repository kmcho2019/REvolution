module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [1:0] state, next_state;

// Define the states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// State transitions
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        case(state)
            A: if(in) state <= B; else state <= A;
            B: if(in) state <= B; else state <= C;
            C: if(in) state <= D; else state <= A;
            D: if(in) state <= B; else state <= C;
            default: state <= A; // default to state A
        endcase
    end
end

// Output logic
always @(state) begin
    case(state)
        A, B, C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0; // default output to 0
    endcase
end

endmodule