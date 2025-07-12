module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = x ? GOT1 : IDLE;
            GOT1:  next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy)
    always @(*) begin
        z = (state == GOT10) && x;
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

endmodule