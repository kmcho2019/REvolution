module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] GOT1  = 2'b01;
    localparam [1:0] GOT10 = 2'b10;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = x ? GOT1 : IDLE;
            GOT1:   next_state = x ? GOT1 : GOT10;
            GOT10:  next_state = x ? GOT1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic - pure combinational
    assign z = (current_state == GOT10) & x;

endmodule