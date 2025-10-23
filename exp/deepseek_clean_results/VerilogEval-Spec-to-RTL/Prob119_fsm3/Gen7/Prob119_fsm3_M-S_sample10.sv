module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) state <= 0;
        else case (state)
            0: state <= in ? 1 : 0;
            1: state <= in ? 1 : 2;
            2: state <= in ? 3 : 0;
            3: state <= in ? 1 : 2;
        endcase
    end

    assign out = (state == 3);

endmodule