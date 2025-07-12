module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

    reg [2:0] state;

    // Next state and output logic
    reg [2:0] next_state;

    always @(*) begin
        case(state)
            3'b000: begin
                if (x == 0)
                    next_state = 3'b000;
                else
                    next_state = 3'b001;
                z = 0;
            end
            3'b001: begin
                if (x == 0)
                    next_state = 3'b001;
                else
                    next_state = 3'b100;
                z = 0;
            end
            3'b010: begin
                if (x == 0)
                    next_state = 3'b010;
                else
                    next_state = 3'b001;
                z = 0;
            end
            3'b011: begin
                if (x == 0)
                    next_state = 3'b001;
                else
                    next_state = 3'b010;
                z = 1;
            end
            3'b100: begin
                if (x == 0)
                    next_state = 3'b011;
                else
                    next_state = 3'b100;
                z = 1;
            end
            default: begin
                // For safety, go to 0 state if invalid
                next_state = 3'b000;
                z = 0;
            end
        endcase
    end

    // On clock edge, update the present state
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output Y0 is the LSB of next_state
    assign Y0 = next_state[0];

    // Initialize state with input y on reset or at start
    // Since no reset is defined, initialize at start to y
    initial begin
        state = y;
    end

endmodule