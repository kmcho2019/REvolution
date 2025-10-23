module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Gray-coded state encoding for power optimization
    parameter IDLE  = 2'b00;
    parameter GOT1  = 2'b01;
    parameter GOT10 = 2'b11;  // Gray code sequence: 00->01->11

    reg [1:0] state;

    // State transition logic with gray coding
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
            endcase
        end
    end

    // Mealy output depends on current state and input
    assign z = (state == GOT10) & x;

endmodule