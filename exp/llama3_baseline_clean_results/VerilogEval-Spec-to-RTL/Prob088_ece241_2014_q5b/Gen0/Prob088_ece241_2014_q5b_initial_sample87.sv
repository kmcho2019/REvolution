module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state, next_state;

// One-hot encoding for states: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Output logic
always @(state or x) begin
    case (state)
        A: z = ~x;
        B: z = x;
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: begin
                if (~x) state <= A;
                else state <= B;
            end
            B: begin
                // State B stays in B regardless of x
                state <= B;
            end
            default: state <= A;
        endcase
    end
end

endmodule