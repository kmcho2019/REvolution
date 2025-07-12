module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    reg [2:0] next_state;
    reg out_z;

    always @(*) begin
        case (y)
            3'b000: begin
                next_state = x ? 3'b001 : 3'b000;
                out_z = 1'b0;
            end
            3'b001: begin
                next_state = x ? 3'b100 : 3'b001;
                out_z = 1'b0;
            end
            3'b010: begin
                next_state = x ? 3'b001 : 3'b010;
                out_z = 1'b0;
            end
            3'b011: begin
                next_state = x ? 3'b010 : 3'b001;
                out_z = 1'b1;
            end
            3'b100: begin
                next_state = x ? 3'b100 : 3'b011;
                out_z = 1'b1;
            end
            default: begin  // Should never occur
                next_state = 3'b000;
                out_z = 1'b0;
            end
        endcase
    end

    assign z = out_z;
    assign Y0 = next_state[0];

endmodule