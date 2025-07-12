module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states as an enumeration
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Current state register
reg [1:0] state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Sequential state transition logic
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

endmodule