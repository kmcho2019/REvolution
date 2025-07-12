module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] counter;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            counter <= 2'b00;
        end else begin
            case (counter)
                2'b00: counter <= x ? 2'b01 : 2'b00;  // Start counting on '1'
                2'b01: counter <= x ? 2'b01 : 2'b10;  // '1' followed by '0'
                2'b10: counter <= x ? 2'b11 : 2'b00;  // '10' followed by '1'
                2'b11: counter <= x ? 2'b01 : 2'b00;  // Reset or continue
            endcase
        end
    end

    // Mealy output: assert when we complete the sequence (transition to 11)
    assign z = (counter == 2'b10) && x;

endmodule