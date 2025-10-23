module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;
    reg [3:0] state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else case (1'b1)
            state[A]: state <= r[0] ? B : r[1] ? C : r[2] ? D : A;
            state[B]: state <= r[0] ? B : A;
            state[C]: state <= r[1] ? C : A;
            state[D]: state <= r[2] ? D : A;
        endcase
    end

    assign g = {state[D], state[C], state[B]};

endmodule