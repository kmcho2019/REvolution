module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00,
                     GOT1  = 2'b01,
                     GOT10 = 2'b10;

    reg [1:0] current_state, next_state;
    reg z_next;

    // State transition and output registration
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            current_state <= next_state;
            z <= z_next;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                z_next = 0;
                next_state = x ? GOT1 : IDLE;
            end
            GOT1: begin
                z_next = 0;
                next_state = x ? GOT1 : GOT10;
            end
            GOT10: begin
                z_next = x;
                next_state = x ? GOT1 : IDLE;
            end
        endcase
    end

endmodule