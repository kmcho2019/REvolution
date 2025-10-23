module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // State encoding
    localparam [2:0] S_CYCLE0 = 3'b000;
    localparam [2:0] S_CYCLE1 = 3'b001;
    localparam [2:0] S_CYCLE2 = 3'b010;
    localparam [2:0] S_CYCLE3 = 3'b011;
    localparam [2:0] S_IDLE   = 3'b100;

    reg [2:0] state;

    // Output is high in all cycle states, low in IDLE
    assign shift_ena = (state != S_IDLE);

    always @(posedge clk) begin
        if (reset) begin
            state <= S_CYCLE0;
        end else begin
            case (state)
                S_CYCLE0: state <= S_CYCLE1;
                S_CYCLE1: state <= S_CYCLE2;
                S_CYCLE2: state <= S_CYCLE3;
                S_CYCLE3: state <= S_IDLE;
                S_IDLE:   state <= S_IDLE;  // Stay here forever
                default:  state <= S_IDLE;
            endcase
        end
    end

endmodule