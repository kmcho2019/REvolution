module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding
    localparam IDLE    = 3'b000;
    localparam GOT1    = 3'b001;
    localparam GOT11   = 3'b010;
    localparam GOT110  = 3'b011;
    localparam PENDING = 3'b100;
    localparam FOUND   = 3'b101;

    reg [2:0] state;
    reg delayed_data;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delayed_data <= 1'b0;
        end else if (state != FOUND) begin
            // Pipeline stage for final bit comparison
            delayed_data <= data;

            // State transitions
            case (state)
                IDLE:    state <= data ? GOT1 : IDLE;
                GOT1:    state <= data ? GOT11 : IDLE;
                GOT11:   state <= data ? GOT11 : GOT110;
                GOT110:  state <= PENDING;
                PENDING: state <= (delayed_data == 1'b1) ? FOUND : IDLE;
                default: state <= state;
            endcase
        end
    end

    assign start_shifting = (state == FOUND);

endmodule