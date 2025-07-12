module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= in ? B : A;
                    out <= 1'b0;
                end
                B: begin
                    state <= in ? B : C;
                    out <= 1'b0;
                end
                C: begin
                    state <= in ? D : A;
                    out <= 1'b0;
                end
                D: begin
                    state <= in ? B : C;
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