module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output reg   Y0,
    output reg   z
);

    reg [2:0] present_state;
    reg [2:0] next_state;

    // Synchronous process for state register update
    // Load initial state from input y asynchronously (reset-like behavior)
    // For this example, let's assume on every clock the present_state captures y first,
    // then follows transitions based on x
    always @(posedge clk) begin
        present_state <= y; // synchronous load of present state input
    end

    // Combinational next state logic based on present_state and x
    always @(*) begin
        case (present_state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000;
        endcase
    end

    // Combinational output logic
    always @(*) begin
        // Y0 is the LSB of next_state
        Y0 = next_state[0];

        // z = 1 when present_state is 3'b011 or 3'b100
        if (present_state == 3'b011 || present_state == 3'b100)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule