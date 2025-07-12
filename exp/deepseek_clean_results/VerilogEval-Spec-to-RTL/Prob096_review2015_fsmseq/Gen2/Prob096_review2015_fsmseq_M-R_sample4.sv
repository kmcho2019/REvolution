module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE   = 3'b000;
    localparam GOT1   = 3'b001;
    localparam GOT11  = 3'b010;
    localparam GOT110 = 3'b011;
    localparam FOUND  = 3'b100;

    reg [2:0] state;

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
                FOUND: state <= FOUND;
                default: state <= IDLE;
            endcase
        end
    end

    // Output assignment
    assign start_shifting = (state == FOUND);

endmodule