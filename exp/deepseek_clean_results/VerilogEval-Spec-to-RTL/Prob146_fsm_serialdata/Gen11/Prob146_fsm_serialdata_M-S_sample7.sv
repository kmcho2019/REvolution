module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Simplified state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;

    // Combinatorial done signal
    assign done = (state == STOP) && in;

    // Combined state and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (&shift_reg[6:0]) begin  // Check if 7 bits received
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        state <= IDLE;
                        out_byte <= {in, shift_reg[7:1]};  // Capture full byte
                    end
                end
            endcase
        end
    end

endmodule