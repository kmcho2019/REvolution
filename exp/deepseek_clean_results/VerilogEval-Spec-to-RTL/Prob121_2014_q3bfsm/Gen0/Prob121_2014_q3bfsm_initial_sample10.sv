module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] y;  // Current state register

    // State definitions (not strictly necessary but makes code more readable)
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;  // Synchronous reset to state 000
        end else begin
            case (y)
                S0: y <= x ? S1 : S0;
                S1: y <= x ? S4 : S1;
                S2: y <= x ? S1 : S2;
                S3: y <= x ? S2 : S1;
                S4: y <= x ? S4 : S3;
                default: y <= S0;  // Default to S0 if undefined state
            endcase
        end
    end

    // Output logic
    assign z = (y == S3) || (y == S4);

endmodule