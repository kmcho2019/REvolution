module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Local parameters for state encoding
    localparam [2:0] S0 = 3'b000,
                     S1 = 3'b001,
                     S2 = 3'b010,
                     S3 = 3'b011,
                     S4 = 3'b100;

    reg [2:0] current_state;

    // Synchronous reset logic
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
    end

    // State transition logic
    always @(posedge clk) begin
        if (!reset) begin
            case (current_state)
                S0: current_state <= x ? S1 : S0;
                S1: current_state <= x ? S4 : S1;
                S2: current_state <= x ? S1 : S2;
                S3: current_state <= x ? S2 : S1;
                S4: current_state <= x ? S4 : S3;
                default: current_state <= S0;
            endcase
        end
    end

    // Output logic using continuous assignment
    assign z = (current_state == S3) || (current_state == S4);

endmodule