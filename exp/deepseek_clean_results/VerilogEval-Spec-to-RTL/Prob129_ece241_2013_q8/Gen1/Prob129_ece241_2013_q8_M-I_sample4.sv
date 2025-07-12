module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Binary state encoding
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] GOT1  = 2'b01;
    localparam [1:0] GOT10 = 2'b10;

    reg [1:0] current_state, next_state;
    reg next_z;

    // Combined state and output register update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= next_z;
        end
    end

    // Combinational next state and output logic
    always @(*) begin
        next_z = 1'b0;
        case (current_state)
            IDLE: begin
                if (x) next_state = GOT1;
                else next_state = IDLE;
            end
            GOT1: begin
                if (!x) next_state = GOT10;
                else next_state = GOT1;
            end
            GOT10: begin
                if (x) begin
                    next_z = 1'b1;
                    next_state = GOT1;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule