module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding (2-bit)
    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safe default
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output from state (output '1' for state B, '0' for A)
    assign out = (state == B);

endmodule