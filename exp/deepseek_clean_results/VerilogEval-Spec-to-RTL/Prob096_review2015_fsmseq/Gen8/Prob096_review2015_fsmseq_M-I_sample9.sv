module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot state encoding
    localparam IDLE  = 5'b00001;
    localparam S1    = 5'b00010;
    localparam S2    = 5'b00100;
    localparam S3    = 5'b01000;
    localparam FOUND = 5'b10000;

    reg [4:0] state;
    wire gated_clk = (state != FOUND) ? clk : 1'b0;

    // State transition logic with clock gating
    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            case (state)
                IDLE:  state <= data ? S1 : IDLE;
                S1:    state <= data ? S2 : IDLE;
                S2:    state <= data ? S2 : S3;
                S3:    state <= data ? FOUND : IDLE;
                FOUND: state <= FOUND;
            endcase
            
            // Registered output
            start_shifting <= (state == FOUND);
        end
    end

endmodule