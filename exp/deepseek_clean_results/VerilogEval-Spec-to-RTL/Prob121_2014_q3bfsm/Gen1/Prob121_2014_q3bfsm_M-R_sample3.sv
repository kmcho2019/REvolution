module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State definitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // State register
    reg [2:0] state;

    // Next state wires
    wire [2:0] next_state;

    // Next state logic (combinational)
    assign next_state = 
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) : S0;

    // State transition (sequential)
    always @(posedge clk) begin
        state <= reset ? S0 : next_state;
    end

    // Output logic (combinational)
    assign z = (state == S3) || (state == S4);

endmodule