module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // One-hot state encoding
    localparam S0 = 3'b0001;
    localparam S1 = 3'b0010;
    localparam S2 = 3'b0100;
    localparam S3 = 3'b1000;
    localparam IDLE = 3'b0000;
    
    reg [3:0] state;

    assign shift_ena = (state != IDLE);

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= S1;
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

endmodule