module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// Define the states as parameters using binary encoding
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register
reg [1:0] state;

// Sequential logic for state transition
always @(posedge clk) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in ? B : A;
            B: state <= in ? B : C;
            C: state <= in ? D : A;
            D: state <= in ? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        A, B, C: out = 1'd0;
        D: out = 1'd1;
        default: out = 1'd0;
    endcase
end

endmodule