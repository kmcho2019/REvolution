module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Binary encoded states
    reg [1:0] current_state, next_state;
    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE:  next_state = x ? GOT1 : IDLE;
            GOT1:  next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
        endcase
    end

    // State register and output register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            current_state <= next_state;
            // Registered output - asserted when in GOT10 and x=1
            z <= (current_state == GOT10) & x;
        end
    end

endmodule