module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg next_z;

    // Next state and output logic
    always @(*) begin
        case (y)
            3'b000: begin
                if (x) next_state = 3'b001;
                else next_state = 3'b000;
                next_z = 1'b0;
            end
            3'b001: begin
                if (x) next_state = 3'b100;
                else next_state = 3'b001;
                next_z = 1'b0;
            end
            3'b010: begin
                if (x) next_state = 3'b001;
                else next_state = 3'b010;
                next_z = 1'b0;
            end
            3'b011: begin
                if (x) next_state = 3'b010;
                else next_state = 3'b001;
                next_z = 1'b1;
            end
            3'b100: begin
                if (x) next_state = 3'b100;
                else next_state = 3'b011;
                next_z = 1'b1;
            end
            default: begin
                next_state = 3'b000;
                next_z = 1'b0;
            end
        endcase
    end

    // Output assignments
    assign Y0 = next_state[0];
    assign z = next_z;

endmodule