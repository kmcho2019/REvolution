module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot encoded states
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Combinational next-state logic (one-hot)
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // safe default
        endcase
    end

    // Sequential logic: state register and registered output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

endmodule