module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;
    wire next_out;

    // Combinational logic for next state
    assign next_state = (state == A) ? ((in == 1'b0) ? A : B) :
                        (state == B) ? ((in == 1'b0) ? C : B) :
                        (state == C) ? ((in == 1'b0) ? A : D) :
                        (state == D) ? ((in == 1'b0) ? C : B) :
                        A;

    // Combinational logic for output (Moore output depends on current state)
    assign next_out = (state == D) ? 1'b1 : 1'b0;

    // Sequential logic: state and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_out;
        end
    end

endmodule