module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;
    
    reg [3:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (1'b1) // Synthesis will recognize this as priority encoder
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Sequential state register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic (pure Moore)
    assign out = state[D];

endmodule