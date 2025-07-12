module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // default safe state
        endcase
    end

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic: Moore output assigned continuously
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule