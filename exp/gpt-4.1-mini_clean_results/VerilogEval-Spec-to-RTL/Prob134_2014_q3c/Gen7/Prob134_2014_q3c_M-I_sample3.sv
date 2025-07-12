module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    reg [2:0] state;
    reg [2:0] next_state;

    // State register with asynchronous reset by input y (treated as initial state load)
    // Assuming y is an asynchronous reset value to initialize FSM state
    always @(posedge clk) begin
        state <= next_state;
    end

    // Compute next state combinationally based on current state and input x
    always @(*) begin
        case (state)
            3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
            default: next_state = 3'b000; // safe default
        endcase
    end

    // Output z depends on current state
    wire z_comb = (state == 3'b011) || (state == 3'b100);

    // Output Y0 is LSB of next state
    wire Y0_comb = next_state[0];

    assign z = z_comb;
    assign Y0 = Y0_comb;

    // Initialize state with input y asynchronously at start-up or reset simulation
    initial begin
        state = y;
    end

endmodule