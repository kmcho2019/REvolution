module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    reg [1:0] state;
    localparam B = 2'b01;
    localparam A = 2'b10;

    // State transitions on both clock edges
    always @(posedge clk, negedge clk) begin
        if (reset) begin
            state <= B;  // Synchronous reset to state B
        end else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
                default: state <= B;  // Handle undefined states
            endcase
        end
    end

    // Output is high only in state B (01)
    assign out = state[0];  // Direct mapping from state bit

endmodule