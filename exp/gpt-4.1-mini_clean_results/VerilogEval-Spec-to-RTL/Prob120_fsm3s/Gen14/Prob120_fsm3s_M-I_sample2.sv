module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot encoding for states: A=0001, B=0010, C=0100, D=1000
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using one-hot states
    always @(*) begin
        case (1'b1) // priority encoding to decode one-hot states
            state[0]: next_state = in ? B : A; // A state
            state[1]: next_state = in ? B : C; // B state
            state[2]: next_state = in ? D : A; // C state
            state[3]: next_state = in ? B : C; // D state
            default:  next_state = A; // safe default
        endcase
    end

    // Output logic is high only in D state
    always @(*) begin
        out = state[3]; // out=1 only if in D
    end

endmodule