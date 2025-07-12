module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output reg Y0,
    output reg z
);

    reg [2:0] state;      // Current state register
    reg [2:0] next_state; // Next state logic

    // Next state and output logic
    always @(*) begin
        case (state)
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
                next_state = 3'b000;
                z = 1'b0;
            end
        endcase
        Y0 = next_state[0];
    end

    // State register update on clock edge, synchronously load input y
    always @(posedge clk) begin
        state <= y;  // load input y each clock cycle as current state
    end

endmodule