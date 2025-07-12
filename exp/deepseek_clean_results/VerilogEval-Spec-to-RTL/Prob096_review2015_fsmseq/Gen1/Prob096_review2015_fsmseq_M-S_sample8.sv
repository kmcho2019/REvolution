module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Binary state encoding
    reg [2:0] state;

    // State transition and output logic combined
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;  // IDLE
            start_shifting <= 1'b0;
        end else begin
            case (state)
                3'b000: state <= data ? 3'b001 : 3'b000;  // IDLE -> S1 or stay
                3'b001: state <= data ? 3'b010 : 3'b000;  // S1 -> S2 or IDLE
                3'b010: state <= data ? 3'b010 : 3'b011;  // S2 -> S2 or S3
                3'b011: state <= data ? 3'b100 : 3'b000;  // S3 -> FOUND or IDLE
                3'b100: state <= 3'b100;                  // FOUND (stay)
                default: state <= 3'b000;
            endcase
            
            // Output is high only in FOUND state
            start_shifting <= (state == 3'b100);
        end
    end

endmodule