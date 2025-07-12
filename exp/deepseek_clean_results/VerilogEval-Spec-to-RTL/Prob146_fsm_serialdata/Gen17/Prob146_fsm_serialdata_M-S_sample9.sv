module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default to 0, set only in STOP state
            
            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        state <= RECEIVE;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first
                    if (&shift_reg[6:0]) begin  // After 7 shifts (8th bit coming)
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in == 1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1;
                        state <= IDLE;
                    end
                    // Else stay in STOP until stop bit received
                end
            endcase
        end
    end

endmodule