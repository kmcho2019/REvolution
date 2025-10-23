module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

// Define states as parameters for readability
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;

// Implement state transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A; // Default to state A
        endcase
    end
end

// Output logic optimized for area and power
always @(state) begin
    case (state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // Default output
    endcase
end

endmodule