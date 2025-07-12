module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state;

    // Next state logic combinational signals
    wire [3:0] next_state;

    // Next state logic combinational block
    assign next_state = (state == A) ? (in ? B : A) :
                        (state == B) ? (in ? B : C) :
                        (state == C) ? (in ? D : A) :
                        (state == D) ? (in ? B : C) :
                        A; // default safe state

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Moore): output is 1 only in state D
    always @(*) begin
        out = (state == D);
    end

endmodule