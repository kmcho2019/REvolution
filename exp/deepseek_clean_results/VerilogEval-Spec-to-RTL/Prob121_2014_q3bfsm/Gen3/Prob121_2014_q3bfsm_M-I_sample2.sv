module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray-coded state encoding
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b011;
    localparam S3 = 3'b010;
    localparam S4 = 3'b110;
    
    reg [2:0] y;  // Present state

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;  // Synchronous reset to state S0
        end else begin
            case (y)
                S0: y <= x ? S1 : S0;
                S1: y <= x ? S4 : S1;
                S2: y <= x ? S1 : S3;
                S3: y <= x ? S1 : S2;
                S4: y <= x ? S4 : S2;
            endcase
        end
    end

    // Output is combinational function of current state
    assign z = (y == S2 || y == S4);

endmodule