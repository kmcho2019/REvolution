module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state;

// Initialize state to A when reset is high
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
        endcase
    end
end

// Determine output based on state
always @(posedge clk) begin
    case (state)
        A: out <= 0;
        B: out <= 0;
        C: out <= 0;
        D: out <= 1;
    endcase
end

endmodule