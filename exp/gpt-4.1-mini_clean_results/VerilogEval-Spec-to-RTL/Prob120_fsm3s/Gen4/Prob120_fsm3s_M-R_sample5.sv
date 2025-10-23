module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state combinational logic using assign-like ternary operators inside always
    always @(*) begin
        next_state = (state == A) ? (in ? B : A) :
                     (state == B) ? (in ? B : C) :
                     (state == C) ? (in ? D : A) :
                     (state == D) ? (in ? B : C) :
                     A; // default to A
    end

    // Sequential logic: state update and Moore output generation combined
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