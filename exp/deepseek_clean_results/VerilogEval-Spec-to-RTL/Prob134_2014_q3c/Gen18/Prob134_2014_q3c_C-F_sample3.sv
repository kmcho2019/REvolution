module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg next_z;

    // Combined next state and output logic
    always @(*) begin
        case ({y, x})
            {3'b000, 1'b0}: begin next_state = 3'b000; next_z = 1'b0; end
            {3'b000, 1'b1}: begin next_state = 3'b001; next_z = 1'b0; end
            {3'b001, 1'b0}: begin next_state = 3'b001; next_z = 1'b0; end
            {3'b001, 1'b1}: begin next_state = 3'b100; next_z = 1'b0; end
            {3'b010, 1'b0}: begin next_state = 3'b010; next_z = 1'b0; end
            {3'b010, 1'b1}: begin next_state = 3'b001; next_z = 1'b0; end
            {3'b011, 1'b0}: begin next_state = 3'b001; next_z = 1'b1; end
            {3'b011, 1'b1}: begin next_state = 3'b010; next_z = 1'b1; end
            {3'b100, 1'b0}: begin next_state = 3'b011; next_z = 1'b1; end
            {3'b100, 1'b1}: begin next_state = 3'b100; next_z = 1'b1; end
        endcase
    end

    // Output assignments
    assign Y0 = next_state[0];
    assign z = next_z;

endmodule