module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic (Mealy)
    always @(*) begin
        case (state)
            IDLE: begin
                z = 0;
                next_state = x ? GOT1 : IDLE;
            end
            GOT1: begin
                z = 0;
                next_state = x ? GOT1 : GOT10;
            end
            GOT10: begin
                z = x;  // Output 1 if we have "10" and current x is 1
                next_state = x ? GOT1 : IDLE;
            end
            default: begin
                z = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule