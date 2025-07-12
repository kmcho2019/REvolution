module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // State encoding for readability and maintainability
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic as continuous assignment for concise combinational logic
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) :
                        S0;  // Safe default

    // State register with synchronous active-high reset and non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: separate combinational always block for timing and power optimization
    always @(*) begin
        case (state)
            S3, S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule