module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam B = 2'b01;
    localparam A = 2'b10;

    reg [1:0] state_hot;

    always @(posedge clk) begin
        if (reset) begin
            state_hot <= B;
        end else begin
            case (state_hot)
                B: state_hot <= (in == 1'b0) ? A : B;
                A: state_hot <= (in == 1'b0) ? B : A;
                default: state_hot <= B; // Safety default
            endcase
        end
    end

    // Moore output from one-hot encoding of states
    // out=1 for state B (2'b01), else 0
    assign out = (state_hot == B);

endmodule