module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Asynchronous reset and state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Reset to state B
        end else begin
            case(state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B; // default safe state
            endcase
        end
    end

    // Moore output depends only on current state
    always @(*) begin
        out = state;
    end

endmodule