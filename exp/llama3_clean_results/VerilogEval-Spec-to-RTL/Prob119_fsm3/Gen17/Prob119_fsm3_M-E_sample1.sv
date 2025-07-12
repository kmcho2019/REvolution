module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot values
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State register
reg [3:0] state;

// Sequential logic with asynchronous reset
always @(posedge clk) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: state <= in? B : A;
            B: state <= in? B : C;
            C: state <= in? D : A;
            D: state <= in? B : C;
            default: state <= A;
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

endmodule