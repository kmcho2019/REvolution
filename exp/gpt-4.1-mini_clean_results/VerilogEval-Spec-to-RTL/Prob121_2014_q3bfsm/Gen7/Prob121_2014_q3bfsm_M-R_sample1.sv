module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state;

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Next state logic as combinational expressions
    wire [2:0] next_state;
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) : S0;

    // Sequential logic: state and output register update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule