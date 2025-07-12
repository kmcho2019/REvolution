module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Binary state encoding
    localparam [2:0] IDLE  = 3'b000;
    localparam [2:0] S1    = 3'b001;
    localparam [2:0] S2    = 3'b010;
    localparam [2:0] S3    = 3'b011;
    localparam [2:0] FOUND = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end
        else begin
            case (state)
                IDLE:  state <= data ? S1 : IDLE;
                S1:    state <= data ? S2 : IDLE;
                S2:    state <= data ? S2 : S3;
                S3:    state <= data ? FOUND : IDLE;
                FOUND: state <= FOUND;
                default: state <= IDLE;
            endcase
            
            start_shifting <= (state == FOUND);
        end
    end

endmodule