module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] state;

    // State definitions:
    // 00: IDLE
    // 01: GOT1
    // 10: GOT11
    // 11: FOUND

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: state <= data ? 2'b01 : 2'b00;  // IDLE -> GOT1 or stay
                2'b01: state <= data ? 2'b10 : 2'b00;  // GOT1 -> GOT11 or reset
                2'b10: state <= data ? 2'b10 : (data ? 2'b11 : 2'b00);  // GOT11 -> stay or FOUND or reset
                2'b11: state <= 2'b11;                // FOUND (stay until reset)
            endcase
        end
    end

    assign start_shifting = (state == 2'b11);

endmodule