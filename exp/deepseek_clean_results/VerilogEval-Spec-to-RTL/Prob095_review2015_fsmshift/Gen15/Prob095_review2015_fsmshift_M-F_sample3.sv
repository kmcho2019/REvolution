module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S0   = 3'd1;
    localparam S1   = 3'd2;
    localparam S2   = 3'd3;
    localparam S3   = 3'd4;

    reg [2:0] state;

    // Output is high only in active states (S0-S3)
    assign shift_ena = (state != IDLE);

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;  // Start counting sequence
        end else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= IDLE;
                default: state <= IDLE;  // Stay in IDLE until next reset
            endcase
        end
    end

endmodule