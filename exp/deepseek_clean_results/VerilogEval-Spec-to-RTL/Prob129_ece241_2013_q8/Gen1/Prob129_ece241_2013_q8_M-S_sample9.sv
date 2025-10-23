module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State parameters
    parameter IDLE  = 2'b00;
    parameter GOT1  = 2'b01;
    parameter GOT10 = 2'b10;

    reg [1:0] state;

    // Combined state transition and output logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    z <= 0;
                    if (x) state <= GOT1;
                end
                GOT1: begin
                    z <= 0;
                    if (!x) state <= GOT10;
                end
                GOT10: begin
                    z <= x;
                    state <= x ? GOT1 : IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule