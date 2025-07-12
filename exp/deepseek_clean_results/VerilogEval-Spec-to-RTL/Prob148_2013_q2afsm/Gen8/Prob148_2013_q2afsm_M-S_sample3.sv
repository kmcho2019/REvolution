module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) state <= 2'b00;
        else case (state)
            2'b00: state <= r[0] ? 2'b01 : r[1] ? 2'b10 : r[2] ? 2'b11 : 2'b00;
            2'b01: state <= r[0] ? 2'b01 : 2'b00;
            2'b10: state <= r[1] ? 2'b10 : 2'b00;
            2'b11: state <= r[2] ? 2'b11 : 2'b00;
        endcase
    end

    assign g = {state == 2'b11, state == 2'b10, state == 2'b01};

endmodule