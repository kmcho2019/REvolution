module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    // Enumerated states using localparams
    localparam [2:0]
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100;

    reg [2:0] state;

    // Next state combinational signals
    wire [2:0] next_state;

    // Define next state logic with assign statements
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) :
                        S0; // default

    // Define output combinational logic with assign and a wire
    wire z_next;
    assign z_next = (state == S3) || (state == S4);

    // Output register update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output registered from combinational output logic
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= z_next;
    end

endmodule