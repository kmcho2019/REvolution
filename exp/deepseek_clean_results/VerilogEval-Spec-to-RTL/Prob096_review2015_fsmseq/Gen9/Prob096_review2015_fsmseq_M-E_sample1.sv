module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot encoded states
    localparam IDLE   = 3'b001;
    localparam GOT1   = 3'b010;
    localparam GOT11  = 3'b100;
    
    reg [2:0] state;
    reg detected;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            detected <= 1'b0;
        end else if (!detected) begin
            case (state)
                IDLE:  state <= (data) ? GOT1 : IDLE;
                GOT1:  state <= (data) ? GOT11 : IDLE;
                GOT11: begin
                    if (!data) state <= IDLE;  // Early termination for non-matching bit
                    detected <= (data) ? 1'b1 : 1'b0;  // Final bit check
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = detected;

endmodule