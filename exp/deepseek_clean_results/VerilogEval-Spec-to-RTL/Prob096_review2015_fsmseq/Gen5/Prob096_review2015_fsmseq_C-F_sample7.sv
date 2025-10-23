module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state;

    // State definitions (comments for clarity)
    // 000: IDLE
    // 001: GOT1
    // 010: GOT11
    // 011: GOT110
    // 100: FOUND

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end else begin
            case (state)
                3'b000: state <= data ? 3'b001 : 3'b000;  // IDLE -> GOT1 or stay
                3'b001: state <= data ? 3'b010 : 3'b000;  // GOT1 -> GOT11 or reset
                3'b010: state <= data ? 3'b010 : 3'b011;  // GOT11 -> stay or GOT110
                3'b011: state <= data ? 3'b100 : 3'b000;  // GOT110 -> FOUND or reset
                3'b100: state <= 3'b100;                  // FOUND (stay until reset)
                default: state <= 3'b000;                 // Safety catch
            endcase
        end
    end

    assign start_shifting = (state == 3'b100);

endmodule