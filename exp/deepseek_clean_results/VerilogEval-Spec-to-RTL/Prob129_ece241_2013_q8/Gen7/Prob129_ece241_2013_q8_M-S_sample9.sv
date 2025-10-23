module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;

    // State encoding
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S1 : S2;
                S2: state <= x ? S1 : S0;
            endcase
        end
    end

    assign z = (state == S2) & x;

endmodule