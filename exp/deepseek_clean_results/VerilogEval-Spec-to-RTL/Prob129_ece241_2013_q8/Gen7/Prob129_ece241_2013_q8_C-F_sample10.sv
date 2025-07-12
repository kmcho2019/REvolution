module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // States represented by shift register contents
    reg [1:0] state;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
        end else begin
            state <= {state[0], x};
        end
    end

    // Mealy output: detect "101" sequence (state="10" and current x="1")
    assign z = (state == 2'b10) && x;

endmodule