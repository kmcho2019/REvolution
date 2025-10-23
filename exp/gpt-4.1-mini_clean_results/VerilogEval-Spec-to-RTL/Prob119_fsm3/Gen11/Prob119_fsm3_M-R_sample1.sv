module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state;

    // Next state combinational logic as continuous assignment with nested ternaries
    wire [1:0] next_state = (state == A) ? (in ? B : A) :
                            (state == B) ? (in ? B : C) :
                            (state == C) ? (in ? D : A) :
                            (state == D) ? (in ? B : C) : A;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: Moore machine output depends only on state D
    assign out = (state == D);

endmodule