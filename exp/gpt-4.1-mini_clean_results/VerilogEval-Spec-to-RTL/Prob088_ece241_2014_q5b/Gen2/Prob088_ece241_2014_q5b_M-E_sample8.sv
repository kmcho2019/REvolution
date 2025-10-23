module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);
    // One-hot encoded states: A=2'b10, B=2'b01
    reg [1:0] state, next_state;

    // State encoding parameters
    localparam A = 2'b10;
    localparam B = 2'b01;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;  // Reset into state A
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;   // A: move to B if x=1, else stay
            B: next_state = B;            // B: stay in B
            default: next_state = A;      // Safety default
        endcase
    end

    // Mealy output logic (combinational)
    always @(*) begin
        case (state)
            A: z = x ? 1'b1 : 1'b0;      // In A, z = x
            B: z = x ? 1'b0 : 1'b1;      // In B, z = ~x
            default: z = 1'b0;
        endcase
    end
endmodule