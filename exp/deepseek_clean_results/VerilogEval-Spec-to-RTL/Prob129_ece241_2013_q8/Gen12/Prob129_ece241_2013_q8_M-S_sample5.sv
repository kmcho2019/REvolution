module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;  // 00: reset, 01: seen 1, 10: seen 0

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= x ? 2'b01 : 2'b00;  // Wait for first 1
                2'b01: state <= x ? 2'b01 : 2'b10;  // After 1, look for 0
                2'b10: state <= x ? 2'b01 : 2'b00;  // After 0, look for 1
                default: state <= 2'b00;
            endcase
        end
    end

    // Mealy output: z=1 when we're in 'seen 0' state and current x is 1
    assign z = (state == 2'b10) && x;

endmodule