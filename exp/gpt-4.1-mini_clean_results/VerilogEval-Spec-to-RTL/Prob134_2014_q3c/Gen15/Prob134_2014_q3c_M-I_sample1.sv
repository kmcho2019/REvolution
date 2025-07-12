module TopModule (
    input        clk,    // clock input (not used)
    input        x,
    input  [2:0] y,      // present state
    output reg   Y0,
    output reg   z
);

    reg [2:0] next_state;

    always @(*) begin
        // Default assignments for safety and to avoid latches
        next_state = 3'b000;
        z = 1'b0;

        case (y)
            3'b000: begin
                if (x == 1'b0) next_state = 3'b000;
                else            next_state = 3'b001;
                z = 1'b0;
            end
            3'b001: begin
                if (x == 1'b0) next_state = 3'b001;
                else            next_state = 3'b100;
                z = 1'b0;
            end
            3'b010: begin
                if (x == 1'b0) next_state = 3'b010;
                else            next_state = 3'b001;
                z = 1'b0;
            end
            3'b011: begin
                if (x == 1'b0) next_state = 3'b001;
                else            next_state = 3'b010;
                z = 1'b1;
            end
            3'b100: begin
                if (x == 1'b0) next_state = 3'b011;
                else            next_state = 3'b100;
                z = 1'b1;
            end
            default: begin
                // Undefined states map to 000 with output 0
                next_state = 3'b000;
                z = 1'b0;
            end
        endcase

        Y0 = next_state[0];
    end

endmodule