module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values using one-hot encoding
localparam A = 2'b01;
localparam B = 2'b10;
localparam C = 2'b11;
localparam D = 2'b00;

// State register
reg [1:0] state;

// Output logic
always_comb begin
    case (state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic for state transition
always_ff @(posedge clk or posedge areset) begin
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

endmodule