module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding using localparam for constants
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    reg [2:0] state;

    // Reset logic in separate always block
    always @(posedge clk) begin
        if (reset)
            state <= S0;
    end

    // State transition logic
    always @(posedge clk) begin
        if (!reset) case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= x ? S4 : S1;
            S2: state <= x ? S1 : S2;
            S3: state <= x ? S2 : S1;
            S4: state <= x ? S4 : S3;
            default: state <= S0;
        endcase
    end

    // Output logic using continuous assign
    assign z = (state == S3) || (state == S4);

endmodule