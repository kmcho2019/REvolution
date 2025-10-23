module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;

    // State encoding
    localparam S_IDLE  = 2'b00;
    localparam S_GOT1  = 2'b01;
    localparam S_GOT10 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE:  state <= x ? S_GOT1 : S_IDLE;
                S_GOT1:  state <= x ? S_GOT1 : S_GOT10;
                S_GOT10: state <= x ? S_GOT1 : S_IDLE;
                default: state <= S_IDLE;
            endcase
        end
    end

    // Mealy output - depends on current state and input
    assign z = (state == S_GOT10) & x;

endmodule