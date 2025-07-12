module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Explicit state encoding
    reg [1:0] state;
    reg x_prev;  // For detecting input changes
    
    // State definitions
    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    // Clock enable signal - only update when input changes
    wire clk_en = (x != x_prev);

    // Sequential logic with async reset and clock gating
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            x_prev <= 1'b0;
        end else if (clk_en) begin
            x_prev <= x;
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Mealy output logic - detects '101' pattern
    assign z = (state == GOT10) & x;

endmodule