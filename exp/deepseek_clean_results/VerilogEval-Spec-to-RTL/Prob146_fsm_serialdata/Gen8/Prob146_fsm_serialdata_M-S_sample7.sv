module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE   = 1'b0;
    localparam RECEIVE = 1'b1;

    reg state;
    reg [3:0] count;  // Counts 0-8 (1 start + 8 data bits)
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
            done <= 0;
        end else begin
            done <= 0;  // Default done to 0
            
            case (state)
                IDLE: begin
                    if (in == 0) begin  // Start bit detected
                        state <= RECEIVE;
                        count <= 0;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    if (count < 8) begin
                        // Shift in data bits (LSB first)
                        shift_reg <= {in, shift_reg[7:1]};
                        count <= count + 1;
                    end else begin
                        // After 8 bits, check stop bit
                        if (in == 1) begin
                            out_byte <= shift_reg;
                            done <= 1;
                        end
                        state <= IDLE;  // Return to IDLE regardless
                    end
                end
            endcase
        end
    end

endmodule