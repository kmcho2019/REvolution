module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot encoding of states
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else begin
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;
            endcase
        end
    end

    // Moore output: output is 1 in state B, 0 in state A
    assign out = state[1]; // state[1] corresponds to B

endmodule