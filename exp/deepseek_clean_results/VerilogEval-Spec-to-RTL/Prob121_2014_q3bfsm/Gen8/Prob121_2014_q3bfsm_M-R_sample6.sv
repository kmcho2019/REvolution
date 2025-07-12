module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding using localparam
    localparam [2:0] S0 = 3'b000;
    localparam [2:0] S1 = 3'b001;
    localparam [2:0] S2 = 3'b010;
    localparam [2:0] S3 = 3'b011;
    localparam [2:0] S4 = 3'b100;

    reg [2:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic
    assign z = (current_state == S3) || (current_state == S4);

endmodule