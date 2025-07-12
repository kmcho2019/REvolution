module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding: 
    // OFF = 2'b01 (output 0)
    // ON  = 2'b10 (output 1)
    reg [1:0] state;

    // Output is MSB of state register
    assign out = state[1];

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01; // Reset to OFF state
        end
        else begin
            case (state)
                2'b01: state <= j ? 2'b10 : 2'b01; // OFF -> ON if j=1, else stay
                2'b10: state <= k ? 2'b01 : 2'b10; // ON -> OFF if k=1, else stay
                default: state <= 2'b01; // Handle any invalid states
            endcase
        end
    end

endmodule