module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= (in == 1'b0) ? A : B;
                    out <= 1'b0;
                end
                B: begin
                    state <= (in == 1'b0) ? C : B;
                    out <= 1'b0;
                end
                C: begin
                    state <= (in == 1'b0) ? A : D;
                    out <= 1'b0;
                end
                D: begin
                    state <= (in == 1'b0) ? C : B;
                    out <= 1'b1;
                end
                default: begin
                    state <= A;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule