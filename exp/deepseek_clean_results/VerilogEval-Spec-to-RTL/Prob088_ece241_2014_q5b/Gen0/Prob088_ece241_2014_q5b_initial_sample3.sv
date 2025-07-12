module TopModule (
    input clk,
    input areset,
    input x,
    output z
);
    // One-hot state encoding: A = 01, B = 10
    reg [1:0] state;

    // Combinational output logic (Mealy machine)
    assign z = (state[0] & x) | (state[1] & ~x);

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A
        end else begin
            case (state)
                2'b01: state <= x ? 2'b10 : 2'b01;  // A -> B if x=1, else stay
                2'b10: state <= 2'b10;              // B always stays
                default: state <= 2'b01;            // Handle undefined states
            endcase
        end
    end
endmodule