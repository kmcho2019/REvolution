module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Define state register
    reg [2:0] state;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
        end
        else begin
            case (state)
                3'b000: state <= x ? 3'b001 : 3'b000;
                3'b001: state <= x ? 3'b100 : 3'b001;
                3'b010: state <= x ? 3'b001 : 3'b010;
                3'b011: state <= x ? 3'b010 : 3'b001;
                3'b100: state <= x ? 3'b100 : 3'b011;
                default: state <= 3'b000;
            endcase
        end
    end

    // Output logic
    assign z = (state == 3'b011 || state == 3'b100) ? 1'b1 : 1'b0;

endmodule