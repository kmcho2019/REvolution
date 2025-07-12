module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Shift register implementation (4 bits to handle all states)
    reg [3:0] state;

    // Output is high when state matches S3 (011) or S4 (100)
    assign z = (state[2:0] == 3'b011) | (state[2:0] == 3'b100);

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Initialize to S0 (000)
        end
        else begin
            case (state[2:0])
                3'b000: state <= x ? 4'b0010 : 4'b0001;  // S0 transitions
                3'b001: state <= x ? 4'b1000 : 4'b0010;  // S1 transitions
                3'b010: state <= x ? 4'b0010 : 4'b0100;  // S2 transitions
                3'b011: state <= x ? 4'b0100 : 4'b0010;  // S3 transitions
                3'b100: state <= x ? 4'b1000 : 4'b0110;   // S4 transitions
                default: state <= 4'b0001;                // Error recovery
            endcase
        end
    end

endmodule