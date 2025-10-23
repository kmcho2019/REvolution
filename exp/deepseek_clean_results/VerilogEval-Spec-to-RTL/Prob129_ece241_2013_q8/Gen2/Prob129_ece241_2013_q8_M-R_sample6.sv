module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State encoding using localparam
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] GOT1  = 2'b01;
    localparam [1:0] GOT10 = 2'b10;

    reg [1:0] current_state, next_state;
    reg z_reg;

    // State transition and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                next_state = x ? GOT1 : IDLE;
                z_reg = 1'b0;
            end
            GOT1: begin
                next_state = x ? GOT1 : GOT10;
                z_reg = 1'b0;
            end
            GOT10: begin
                next_state = x ? GOT1 : IDLE;
                z_reg = x ? 1'b1 : 1'b0;
            end
            default: begin
                next_state = IDLE;
                z_reg = 1'b0;
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Continuous output assignment
    assign z = z_reg;

endmodule