module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) state <= 0;
        else case (state)
            0: state <= r[0] ? 1 : r[1] ? 2 : r[2] ? 3 : 0;
            1: state <= r[0] ? 1 : 0;
            2: state <= r[1] ? 2 : 0;
            3: state <= r[2] ? 3 : 0;
        endcase
    end

    assign g = {state == 3, state == 2, state == 1};

endmodule