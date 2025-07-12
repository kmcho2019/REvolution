module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Define states
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                B: if (in == 1'b0) state <= A; else state <= B;
                A: if (in == 1'b0) state <= B; else state <= A;
                default: state <= B;
            endcase
        end
    end

    // Moore output depends only on state
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule