module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state, next_state;

    // Next state and output combinational logic
    always @(*) begin
        case(state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
                out = 1'b1; // output for B
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
                out = 1'b0; // output for A
            end
            default: begin
                next_state = B; // default to B on invalid state
                out = 1'b1;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

endmodule