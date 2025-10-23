module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                    else if (r[2]) state <= D;
                end
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                D: state <= A;  // State D immediately returns to A
            endcase
        end
    end

    // Output assignments
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule