module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Asynchronous reset and state update with direct combinational next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
                default: state <= B;
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = state;

endmodule