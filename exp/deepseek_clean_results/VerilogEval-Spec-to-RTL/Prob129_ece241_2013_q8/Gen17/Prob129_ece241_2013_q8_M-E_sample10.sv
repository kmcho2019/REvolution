module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;
    reg x_prev;  // Stores previous x value for edge detection

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
            x_prev <= 1'b0;
        end else begin
            x_prev <= x;
            case (state)
                2'b00: state <= (x & ~x_prev) ? 2'b01 : 2'b00;  // Detect rising edge
                2'b01: state <= (~x & x_prev) ? 2'b10 : (x ? 2'b01 : 2'b00);
                2'b10: state <= (x & ~x_prev) ? 2'b01 : 2'b00;
                default: state <= 2'b00;
            endcase
        end
    end

    // Mealy output: detect when in state '10' and see rising edge
    assign z = (state == 2'b10) & x & ~x_prev;

endmodule