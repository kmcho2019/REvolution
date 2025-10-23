module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding using localparam for synthesis clarity
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state, next_state;

    // Next state combinational logic using always @(*) with case statement for clear priority and good synthesis
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // safe default state
        endcase
    end

    // State register with asynchronous reset to state A, synchronous next state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic depends only on current state D
    assign out = (state == D);

endmodule