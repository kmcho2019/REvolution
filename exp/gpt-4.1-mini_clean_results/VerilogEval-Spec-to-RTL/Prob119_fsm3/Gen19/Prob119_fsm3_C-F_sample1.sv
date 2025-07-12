module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding with parameters for clarity and area efficiency
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Next state combinational logic using continuous assignment (ternary operators)
    wire [1:0] next_state = (state == A) ? (in ? B : A) :
                            (state == B) ? (in ? B : C) :
                            (state == C) ? (in ? D : A) :
                            (state == D) ? (in ? B : C) :
                            A; // default fallback

    // Sequential logic: state update with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore machine output derived directly from state D
    assign out = (state == D);

endmodule