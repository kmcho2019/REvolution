module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
            out   <= B;
        end else begin
            case (state)
                B: begin
                    state <= in ? B : A;
                    out   <= B;
                end
                A: begin
                    state <= in ? A : B;
                    out   <= A;
                end
                default: begin
                    state <= B;
                    out   <= B;
                end
            endcase
        end
    end

endmodule