module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT10
    } state_t;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                z = 0;
                if (x) next_state = GOT1;
                else next_state = IDLE;
            end
            GOT1: begin
                z = 0;
                if (!x) next_state = GOT10;
                else next_state = GOT1;
            end
            GOT10: begin
                if (x) begin
                    z = 1;
                    next_state = GOT1;
                end else begin
                    z = 0;
                    next_state = IDLE;
                end
            end
            default: begin
                z = 0;
                next_state = IDLE;
            end
        endcase
    end

endmodule