module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State definitions
    parameter IDLE   = 3'b000;
    parameter GOT1   = 3'b001;
    parameter GOT11  = 3'b010;
    parameter GOT110 = 3'b011;
    parameter FOUND  = 3'b100;

    reg [2:0] state;

    // Continuous output assignment
    assign start_shifting = (state == FOUND);

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= data ? GOT1 : IDLE;
                GOT1:   state <= data ? GOT11 : IDLE;
                GOT11:  state <= data ? GOT11 : GOT110;
                GOT110: state <= data ? FOUND : IDLE;
                FOUND:  state <= FOUND; // Stay here until reset
                default: state <= IDLE;
            endcase
        end
    end

endmodule