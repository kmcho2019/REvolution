module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding using localparam for clarity and area-efficient binary encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state combinational logic using case statement for clarity and synthesis friendliness
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Safe default
        endcase
    end

    // State register with asynchronous active-high reset and nonblocking assignments
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output as combinational wire derived from current state for clean synthesis and no inferred latches
    assign out = (state == D);

endmodule