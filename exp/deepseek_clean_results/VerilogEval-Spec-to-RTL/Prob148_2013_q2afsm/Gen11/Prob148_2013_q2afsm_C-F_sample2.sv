module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits for 4 states)
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else case (state)
            A: state <= r[0] ? B : r[1] ? C : r[2] ? D : A;
            B: state <= r[0] ? B : A;
            C: state <= r[1] ? C : A;
            D: state <= r[2] ? D : A;
        endcase
    end

    // Output logic - explicit but minimal
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule