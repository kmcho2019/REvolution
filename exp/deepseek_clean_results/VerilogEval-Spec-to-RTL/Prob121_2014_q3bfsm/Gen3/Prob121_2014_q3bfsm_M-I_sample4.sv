module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    wire clk_en;

    // State definitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // Clock gating logic - only enable when state changes
    assign clk_en = reset | 
                   (state == S0 && x) | 
                   (state == S1 && x) | 
                   (state == S2 && x) | 
                   (state == S3) | 
                   (state == S4 && !x);

    // State transition and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 0;
        end else if (clk_en) begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S4 : S1;
                S2: state <= x ? S1 : S2;
                S3: state <= x ? S2 : S1;
                S4: state <= x ? S4 : S3;
            endcase
            z <= (state == S3) || (state == S4);
        end
    end

endmodule