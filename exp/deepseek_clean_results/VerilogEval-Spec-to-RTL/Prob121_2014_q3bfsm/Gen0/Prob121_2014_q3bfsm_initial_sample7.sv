module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State register (3 bits)
    reg [2:0] state;

    // Next state logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;  // Synchronous reset to state 000
        end else begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b100 : 3'b001;
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: state <= x ? 3'b010 : 3'b001;
                3'b100: state <= x ? 3'b100 : 3'b011;
                default: state <= 3'b000;  // Default to state 000 if undefined state
            endcase
        end
    end

    // Output logic (combinational)
    assign z = (state == 3'b011) || (state == 3'b100);

endmodule