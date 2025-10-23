module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else begin
            case(state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S4 : S1;
                S2: state <= x ? S1 : S2;
                S3: state <= x ? S2 : S1;
                S4: state <= x ? S4 : S3;
                default: state <= S0;
            endcase
        end
    end

    // Output logic combinational based on current state
    always @(*) begin
        z = (state == S3) || (state == S4);
    end

endmodule