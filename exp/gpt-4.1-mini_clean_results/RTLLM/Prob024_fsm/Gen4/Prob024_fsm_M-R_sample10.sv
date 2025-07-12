module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding (binary)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state;

    // Next state combinational logic
    wire [2:0] next_state;

    assign next_state = (state == S0) ? ((IN == 1'b1) ? S1 : S0) :
                        (state == S1) ? ((IN == 1'b0) ? S2 : S1) :
                        (state == S2) ? ((IN == 1'b0) ? S3 : S1) :
                        (state == S3) ? ((IN == 1'b1) ? S4 : S0) :
                        (state == S4) ? ((IN == 1'b1) ? S5 : S2) :
                        (state == S5) ? ((IN == 1'b0) ? S2 : S1) :
                        S0;

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // MATCH output combinational logic (Mealy)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule