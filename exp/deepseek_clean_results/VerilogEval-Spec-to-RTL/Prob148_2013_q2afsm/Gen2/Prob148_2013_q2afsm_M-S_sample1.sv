module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // State A
        else case (state)
            2'b00: // State A
                if (r[0]) state <= 2'b01; // B
                else if (r[1]) state <= 2'b10; // C
            2'b01: // State B
                if (!r[0]) state <= 2'b00; // A
            2'b10: // State C
                if (!r[1]) state <= 2'b00; // A
        endcase
    end

    assign g = {state == 2'b10, state == 2'b01, 1'b0}; // {g1, g0, 0}

endmodule